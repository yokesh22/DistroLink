import 'package:freezed_annotation/freezed_annotation.dart';

part 'shop.freezed.dart';
part 'shop.g.dart';

@freezed
abstract class Shop with _$Shop {
  const factory Shop({
    required String id,
    @JsonKey(name: 'area_id') required String areaId,
    @JsonKey(name: 'shop_name') required String shopName,
    @JsonKey(name: 'shop_number') required String shopNumber,
    @JsonKey(name: 'shop_address') required String shopAddress,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _Shop;

  factory Shop.fromJson(Map<String, dynamic> json) => _$ShopFromJson(json);
}
