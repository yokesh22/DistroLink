import 'package:distro_link/features/auth/domain/app_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminSalesmenRepository {
  const AdminSalesmenRepository(this._client);
  final SupabaseClient _client;

  Future<List<Salesman>> list(String distributorId) async {
    final rows = await _client
        .from('salesmen')
        .select()
        .eq('distributor_id', distributorId)
        .order('name');
    return rows.map(Salesman.fromJson).toList();
  }

  /// Creates both the auth user (via Edge Function) and the
  /// public.users + public.salesmen rows in one logical operation.
  Future<Salesman> create({
    required String distributorId,
    required String fullName,
    required String phone,
    required String email,
    required String password,
  }) async {
    // Step 1: create auth user via Edge Function.
    final response = await _client.functions.invoke(
      'create-user',
      body: {'email': email, 'password': password},
    );
    if (response.status != 200) {
      final msg = (response.data as Map<String, dynamic>?)?['error']
          as String? ??
          'Failed to create auth user';
      throw Exception(msg);
    }
    final authUserId = (response.data as Map<String, dynamic>)['auth_user_id']
        as String;

    // Step 2: insert into public.users.
    final userRow = await _client
        .from('users')
        .insert({
          'auth_user_id': authUserId,
          'distributor_id': distributorId,
          'role': 'salesman',
          'full_name': fullName.trim(),
          'phone': phone.trim(),
          'email': email.trim(),
          'is_active': true,
        })
        .select('id')
        .single();
    final userId = userRow['id'] as String;

    // Step 3: insert into public.salesmen.
    final salesmanRow = await _client
        .from('salesmen')
        .insert({
          'distributor_id': distributorId,
          'user_id': userId,
          'name': fullName.trim(),
          'phone': phone.trim(),
          'email': email.trim(),
          'is_active': true,
        })
        .select()
        .single();

    return Salesman.fromJson(salesmanRow);
  }

  Future<Salesman> update({
    required String id,
    required String userId,
    required String fullName,
    required String phone,
    required String email,
  }) async {
    // Update both tables in parallel.
    await Future.wait([
      _client
          .from('users')
          .update({
            'full_name': fullName.trim(),
            'phone': phone.trim(),
            'email': email.trim(),
          })
          .eq('id', userId),
      _client
          .from('salesmen')
          .update({
            'name': fullName.trim(),
            'phone': phone.trim(),
            'email': email.trim(),
          })
          .eq('id', id),
    ]);

    final row = await _client
        .from('salesmen')
        .select()
        .eq('id', id)
        .single();
    return Salesman.fromJson(row);
  }

  Future<void> toggleActive({
    required String salesmanId,
    required String userId,
    required bool isActive,
  }) =>
      Future.wait([
        _client
            .from('salesmen')
            .update({'is_active': isActive})
            .eq('id', salesmanId),
        _client
            .from('users')
            .update({'is_active': isActive})
            .eq('id', userId),
      ]);

  Future<void> resetPassword({
    required String userId,
    required String newPassword,
  }) async {
    final response = await _client.functions.invoke(
      'update-user-password',
      body: {'userId': userId, 'newPassword': newPassword},
    );
    if (response.status != 200) {
      final msg = (response.data as Map<String, dynamic>?)?['error'] as String?
          ?? 'Failed to reset password';
      throw Exception(msg);
    }
  }
}
