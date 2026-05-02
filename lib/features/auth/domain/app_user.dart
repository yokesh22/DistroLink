import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

enum UserRole {
  @JsonValue('super_admin')
  superAdmin,
  @JsonValue('admin')
  admin,
  @JsonValue('salesman')
  salesman,
}

/// The app-level identity record — a join between auth.users and the
/// users table that carries the distributor assignment and role.
@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    required String id,
    @JsonKey(name: 'auth_user_id') required String authUserId,
    @JsonKey(name: 'distributor_id') required String distributorId,
    required UserRole role,
    @JsonKey(name: 'full_name') required String fullName,
    required String phone,
    required String email,
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}

/// The salesman entity row — distinct from [AppUser], which is auth/identity.
/// Orders FK to [Salesman.id], not [AppUser.id].
@freezed
abstract class Salesman with _$Salesman {
  const factory Salesman({
    required String id,
    @JsonKey(name: 'distributor_id') required String distributorId,
    required String name,
    required String phone,
    required String email,
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    // Optional — null when the salesman record has no linked login yet
    @JsonKey(name: 'user_id') String? userId,
  }) = _Salesman;

  factory Salesman.fromJson(Map<String, dynamic> json) =>
      _$SalesmanFromJson(json);
}
