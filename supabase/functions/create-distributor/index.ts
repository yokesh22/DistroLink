import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};

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

    // Guard: reject if a users row already exists for this auth user (prevent double-signup).
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

    // Insert distributor row.
    const { data: distributor, error: distErr } = await adminClient
      .from('distributors')
      .insert({ name: businessName.trim(), phone: phone.trim(), email: email.trim() })
      .select('id')
      .single();

    if (distErr) throw distErr;

    // Insert users row with admin role scoped to the new distributor.
    const { error: usersErr } = await adminClient
      .from('users')
      .insert({
        auth_user_id: authUserId,
        distributor_id: distributor.id,
        role: 'admin',
        full_name: fullName.trim(),
        phone: phone.trim(),
        email: email.trim(),
        is_active: true,
      });

    if (usersErr) {
      // Roll back the distributor row to avoid orphan data.
      await adminClient.from('distributors').delete().eq('id', distributor.id);
      throw usersErr;
    }

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
