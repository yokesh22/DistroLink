import 'package:freezed_annotation/freezed_annotation.dart';

part 'distributor.freezed.dart';
part 'distributor.g.dart';

@freezed
abstract class Distributor with _$Distributor {
  const factory Distributor({
    required String id,
    required String name,
    required String phone,
    required String email,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _Distributor;

  factory Distributor.fromJson(Map<String, dynamic> json) =>
      _$DistributorFromJson(json);
}
