import 'package:distro_link/features/shops/domain/shop.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminShopsRepository {
  const AdminShopsRepository(this._client);
  final SupabaseClient _client;

  Future<List<Shop>> list(String distributorId) async {
    // Shops aren't directly scoped by distributor_id in the schema,
    // but areas are accessible to the logged-in admin via RLS.
    final rows = await _client
        .from('shops')
        .select(
          'id, area_id, shop_name, shop_number, shop_address, '
          'shop_owner, phone_no, gstin, created_at',
        )
        .order('shop_name');
    return rows.map(Shop.fromJson).toList();
  }

  Future<Shop> create({
    required String areaId,
    required String shopName,
    required String shopAddress,
    String? shopNumber,
    String? shopOwner,
    String? phoneNo,
    String? gstin,
  }) async {
    final row = await _client
        .from('shops')
        .insert({
          'area_id': areaId,
          'shop_name': shopName.trim(),
          'shop_address': shopAddress.trim(),
          if (shopNumber != null && shopNumber.isNotEmpty)
            'shop_number': shopNumber.trim(),
          if (shopOwner != null && shopOwner.isNotEmpty)
            'shop_owner': shopOwner.trim(),
          if (phoneNo != null && phoneNo.isNotEmpty)
            'phone_no': phoneNo.trim(),
          if (gstin != null && gstin.isNotEmpty) 'gstin': gstin.trim(),
        })
        .select()
        .single();
    return Shop.fromJson(row);
  }

  Future<Shop> update({
    required String id,
    required String areaId,
    required String shopName,
    required String shopAddress,
    String? shopNumber,
    String? shopOwner,
    String? phoneNo,
    String? gstin,
  }) async {
    final row = await _client
        .from('shops')
        .update({
          'area_id': areaId,
          'shop_name': shopName.trim(),
          'shop_address': shopAddress.trim(),
          'shop_number': shopNumber?.trim(),
          'shop_owner': shopOwner?.trim(),
          'phone_no': phoneNo?.trim(),
          'gstin': gstin?.trim(),
        })
        .eq('id', id)
        .select()
        .single();
    return Shop.fromJson(row);
  }
}
