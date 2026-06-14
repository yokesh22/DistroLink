import 'package:freezed_annotation/freezed_annotation.dart';

part 'area.freezed.dart';
part 'area.g.dart';

@freezed
abstract class Area with _$Area {
  const factory Area({
    required String id,
    required String name,
    @JsonKey(name: 'distributor_id') required String distributorId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _Area;

  factory Area.fromJson(Map<String, dynamic> json) => _$AreaFromJson(json);
}
