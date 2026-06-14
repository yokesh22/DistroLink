import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};

// Files a *pending* distributor signup request. Runs right after auth.signUp,
// before email confirmation, so there is no user session yet — the caller is
// anon. We verify the authUserId server-side (service role) to prevent spoofing.
// The distributor + users rows are NOT created here — that happens only when a
// super_admin approves (review-signup-request).
serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    const { authUserId, businessName, fullName, phone, email } = await req.json();

    if (!authUserId || !businessName || !fullName || !phone || !email) {
      return new Response(
        JSON.stringify({ error: 'authUserId, businessName, fullName, phone, and email are required' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } },
      );
    }

    const adminClient = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
    );

    // Verify the auth user actually exists (prevents spoofing a foreign authUserId).
    const { data: { user }, error: userErr } = await adminClient.auth.admin.getUserById(authUserId);
    if (userErr || !user) {
      return new Response(
        JSON.stringify({ error: 'Invalid authUserId' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } },
      );
    }

    // If the account is already provisioned, there is nothing to request.
    const { data: existingUser } = await adminClient
      .from('users')
      .select('id')
      .eq('auth_user_id', authUserId)
      .maybeSingle();

    if (existingUser) {
      return new Response(
        JSON.stringify({ error: 'Account already set up' }),
        { status: 409, headers: { ...corsHeaders, 'Content-Type': 'application/json' } },
      );
    }

    // Upsert the pending request (idempotent on retries). ignoreDuplicates keeps
    // an already-reviewed row intact — a rejected applicant can't resurrect it.
    const { error: insertErr } = await adminClient
      .from('signup_requests')
      .upsert(
        {
          auth_user_id: authUserId,
          business_name: businessName.trim(),
          full_name: fullName.trim(),
          phone: phone.trim(),
          email: email.trim(),
          status: 'pending',
        },
        { onConflict: 'auth_user_id', ignoreDuplicates: true },
      );

    if (insertErr) throw insertErr;

    return new Response(
      JSON.stringify({ success: true }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } },
    );
  } catch (e) {
    return new Response(
      JSON.stringify({ error: (e as Error).message ?? 'Unexpected error' }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } },
    );
  }
});
