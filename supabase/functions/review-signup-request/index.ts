import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};

function json(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
  });
}

// Super-admin-only review of a distributor signup request. Allowed from any
// state, so a super admin can flip an account between approved and declined.
//   action='approve' -> requires the applicant's email be verified. Provisions
//                       the distributor + users (role=admin) rows the first time,
//                       or re-activates an existing (previously revoked) account.
//                       Marks the request approved.
//   action='reject'  -> disables the account (users.is_active = false) if it was
//                       already provisioned, non-destructively (distributor +
//                       orders are kept). Marks the request rejected with an
//                       optional reason. The app shows a "declined" screen.
serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    const adminClient = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
    );

    // ── Authn/authz: caller must be a signed-in super_admin ──────────────
    const authHeader = req.headers.get('Authorization') ?? '';
    const userClient = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_ANON_KEY')!,
      { global: { headers: { Authorization: authHeader } } },
    );
    const { data: { user: caller } } = await userClient.auth.getUser();
    if (!caller) return json({ error: 'Not authenticated' }, 401);

    const { data: callerRow } = await adminClient
      .from('users')
      .select('role')
      .eq('auth_user_id', caller.id)
      .maybeSingle();
    if (callerRow?.role !== 'super_admin') {
      return json({ error: 'Only a super admin can review requests' }, 403);
    }

    // ── Input ────────────────────────────────────────────────────────────
    const { requestId, action, rejectionReason } = await req.json();
    if (!requestId || (action !== 'approve' && action !== 'reject')) {
      return json({ error: "requestId and action ('approve'|'reject') are required" }, 400);
    }

    const { data: reqRow } = await adminClient
      .from('signup_requests')
      .select('*')
      .eq('id', requestId)
      .maybeSingle();
    if (!reqRow) return json({ error: 'Request not found' }, 404);

    // ── Reject ───────────────────────────────────────────────────────────
    if (action === 'reject') {
      // Revoke access if the account was already provisioned (approved before).
      await adminClient
        .from('users')
        .update({ is_active: false })
        .eq('auth_user_id', reqRow.auth_user_id);

      const { error: rejErr } = await adminClient
        .from('signup_requests')
        .update({
          status: 'rejected',
          rejection_reason: (rejectionReason as string | undefined)?.trim() || null,
          reviewed_by: caller.id,
          reviewed_at: new Date().toISOString(),
        })
        .eq('id', requestId);
      if (rejErr) throw rejErr;
      return json({ success: true });
    }

    // ── Approve ──────────────────────────────────────────────────────────
    // Enforce: email must be verified before we provision an account.
    const { data: { user: applicant } } =
      await adminClient.auth.admin.getUserById(reqRow.auth_user_id);
    if (!applicant) return json({ error: 'Applicant auth user no longer exists' }, 410);
    if (!applicant.email_confirmed_at) {
      return json({ error: 'Applicant has not verified their email yet' }, 422);
    }

    // Provision the first time; re-activate if it was provisioned before.
    const { data: existingUser } = await adminClient
      .from('users')
      .select('id')
      .eq('auth_user_id', reqRow.auth_user_id)
      .maybeSingle();

    if (existingUser) {
      const { error: reactivateErr } = await adminClient
        .from('users')
        .update({ is_active: true })
        .eq('id', existingUser.id);
      if (reactivateErr) throw reactivateErr;
    } else {
      const { data: distributor, error: distErr } = await adminClient
        .from('distributors')
        .insert({
          name: reqRow.business_name,
          phone: reqRow.phone,
          email: reqRow.email,
        })
        .select('id')
        .single();
      if (distErr) throw distErr;

      const { error: usersErr } = await adminClient.from('users').insert({
        auth_user_id: reqRow.auth_user_id,
        distributor_id: distributor.id,
        role: 'admin',
        full_name: reqRow.full_name,
        phone: reqRow.phone,
        email: reqRow.email,
        is_active: true,
      });
      if (usersErr) {
        // Roll back the distributor row to avoid orphan data.
        await adminClient.from('distributors').delete().eq('id', distributor.id);
        throw usersErr;
      }
    }

    const { error: appErr } = await adminClient
      .from('signup_requests')
      .update({
        status: 'approved',
        reviewed_by: caller.id,
        reviewed_at: new Date().toISOString(),
      })
      .eq('id', requestId);
    if (appErr) throw appErr;

    return json({ success: true });
  } catch (e) {
    return json({ error: (e as Error).message ?? 'Unexpected error' }, 500);
  }
});
