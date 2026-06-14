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

// Super-admin-only: returns signup requests enriched with `email_verified`
// (read from auth.users.email_confirmed_at, which the client cannot see).
// Optional body { status } filters by status; defaults to all.
serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    const adminClient = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
    );

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
      return json({ error: 'Only a super admin can list requests' }, 403);
    }

    let status: string | undefined;
    try {
      const body = await req.json();
      status = body?.status;
    } catch (_) {
      // No body — return all.
    }

    let query = adminClient
      .from('signup_requests')
      .select('*')
      .order('created_at', { ascending: false });
    if (status) query = query.eq('status', status);

    const { data: rows, error } = await query;
    if (error) throw error;

    // Enrich each row with email verification status from auth.
    const enriched = await Promise.all(
      (rows ?? []).map(async (row) => {
        const { data: { user } } =
          await adminClient.auth.admin.getUserById(row.auth_user_id);
        return { ...row, email_verified: !!user?.email_confirmed_at };
      }),
    );

    return json({ requests: enriched });
  } catch (e) {
    return json({ error: (e as Error).message ?? 'Unexpected error' }, 500);
  }
});
