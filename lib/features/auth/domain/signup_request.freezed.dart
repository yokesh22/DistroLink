// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'signup_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SignupRequest {

 String get id;@JsonKey(name: 'auth_user_id') String get authUserId;@JsonKey(name: 'business_name') String get businessName;@JsonKey(name: 'full_name') String get fullName; String get phone; String get email; SignupRequestStatus get status;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'rejection_reason') String? get rejectionReason;@JsonKey(name: 'reviewed_at') DateTime? get reviewedAt;// Only populated by list-signup-requests (joins auth.users); defaults false
// on a plain self-read where verification status isn't exposed.
@JsonKey(name: 'email_verified') bool get emailVerified;
/// Create a copy of SignupRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignupRequestCopyWith<SignupRequest> get copyWith => _$SignupRequestCopyWithImpl<SignupRequest>(this as SignupRequest, _$identity);

  /// Serializes this SignupRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignupRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.authUserId, authUserId) || other.authUserId == authUserId)&&(identical(other.businessName, businessName) || other.businessName == businessName)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason)&&(identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt)&&(identical(other.emailVerified, emailVerified) || other.emailVerified == emailVerified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,authUserId,businessName,fullName,phone,email,status,createdAt,rejectionReason,reviewedAt,emailVerified);

@override
String toString() {
  return 'SignupRequest(id: $id, authUserId: $authUserId, businessName: $businessName, fullName: $fullName, phone: $phone, email: $email, status: $status, createdAt: $createdAt, rejectionReason: $rejectionReason, reviewedAt: $reviewedAt, emailVerified: $emailVerified)';
}


}

/// @nodoc
abstract mixin class $SignupRequestCopyWith<$Res>  {
  factory $SignupRequestCopyWith(SignupRequest value, $Res Function(SignupRequest) _then) = _$SignupRequestCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'auth_user_id') String authUserId,@JsonKey(name: 'business_name') String businessName,@JsonKey(name: 'full_name') String fullName, String phone, String email, SignupRequestStatus status,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'rejection_reason') String? rejectionReason,@JsonKey(name: 'reviewed_at') DateTime? reviewedAt,@JsonKey(name: 'email_verified') bool emailVerified
});




}
/// @nodoc
class _$SignupRequestCopyWithImpl<$Res>
    implements $SignupRequestCopyWith<$Res> {
  _$SignupRequestCopyWithImpl(this._self, this._then);

  final SignupRequest _self;
  final $Res Function(SignupRequest) _then;

/// Create a copy of SignupRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? authUserId = null,Object? businessName = null,Object? fullName = null,Object? phone = null,Object? email = null,Object? status = null,Object? createdAt = null,Object? rejectionReason = freezed,Object? reviewedAt = freezed,Object? emailVerified = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,authUserId: null == authUserId ? _self.authUserId : authUserId // ignore: cast_nullable_to_non_nullable
as String,businessName: null == businessName ? _self.businessName : businessName // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SignupRequestStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,reviewedAt: freezed == reviewedAt ? _self.reviewedAt : reviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,emailVerified: null == emailVerified ? _self.emailVerified : emailVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SignupRequest].
extension SignupRequestPatterns on SignupRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SignupRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SignupRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SignupRequest value)  $default,){
final _that = this;
switch (_that) {
case _SignupRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SignupRequest value)?  $default,){
final _that = this;
switch (_that) {
case _SignupRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'auth_user_id')  String authUserId, @JsonKey(name: 'business_name')  String businessName, @JsonKey(name: 'full_name')  String fullName,  String phone,  String email,  SignupRequestStatus status, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'rejection_reason')  String? rejectionReason, @JsonKey(name: 'reviewed_at')  DateTime? reviewedAt, @JsonKey(name: 'email_verified')  bool emailVerified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SignupRequest() when $default != null:
return $default(_that.id,_that.authUserId,_that.businessName,_that.fullName,_that.phone,_that.email,_that.status,_that.createdAt,_that.rejectionReason,_that.reviewedAt,_that.emailVerified);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'auth_user_id')  String authUserId, @JsonKey(name: 'business_name')  String businessName, @JsonKey(name: 'full_name')  String fullName,  String phone,  String email,  SignupRequestStatus status, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'rejection_reason')  String? rejectionReason, @JsonKey(name: 'reviewed_at')  DateTime? reviewedAt, @JsonKey(name: 'email_verified')  bool emailVerified)  $default,) {final _that = this;
switch (_that) {
case _SignupRequest():
return $default(_that.id,_that.authUserId,_that.businessName,_that.fullName,_that.phone,_that.email,_that.status,_that.createdAt,_that.rejectionReason,_that.reviewedAt,_that.emailVerified);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'auth_user_id')  String authUserId, @JsonKey(name: 'business_name')  String businessName, @JsonKey(name: 'full_name')  String fullName,  String phone,  String email,  SignupRequestStatus status, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'rejection_reason')  String? rejectionReason, @JsonKey(name: 'reviewed_at')  DateTime? reviewedAt, @JsonKey(name: 'email_verified')  bool emailVerified)?  $default,) {final _that = this;
switch (_that) {
case _SignupRequest() when $default != null:
return $default(_that.id,_that.authUserId,_that.businessName,_that.fullName,_that.phone,_that.email,_that.status,_that.createdAt,_that.rejectionReason,_that.reviewedAt,_that.emailVerified);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SignupRequest implements SignupRequest {
  const _SignupRequest({required this.id, @JsonKey(name: 'auth_user_id') required this.authUserId, @JsonKey(name: 'business_name') required this.businessName, @JsonKey(name: 'full_name') required this.fullName, required this.phone, required this.email, required this.status, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'rejection_reason') this.rejectionReason, @JsonKey(name: 'reviewed_at') this.reviewedAt, @JsonKey(name: 'email_verified') this.emailVerified = false});
  factory _SignupRequest.fromJson(Map<String, dynamic> json) => _$SignupRequestFromJson(json);

@override final  String id;
@override@JsonKey(name: 'auth_user_id') final  String authUserId;
@override@JsonKey(name: 'business_name') final  String businessName;
@override@JsonKey(name: 'full_name') final  String fullName;
@override final  String phone;
@override final  String email;
@override final  SignupRequestStatus status;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'rejection_reason') final  String? rejectionReason;
@override@JsonKey(name: 'reviewed_at') final  DateTime? reviewedAt;
// Only populated by list-signup-requests (joins auth.users); defaults false
// on a plain self-read where verification status isn't exposed.
@override@JsonKey(name: 'email_verified') final  bool emailVerified;

/// Create a copy of SignupRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SignupRequestCopyWith<_SignupRequest> get copyWith => __$SignupRequestCopyWithImpl<_SignupRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SignupRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SignupRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.authUserId, authUserId) || other.authUserId == authUserId)&&(identical(other.businessName, businessName) || other.businessName == businessName)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason)&&(identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt)&&(identical(other.emailVerified, emailVerified) || other.emailVerified == emailVerified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,authUserId,businessName,fullName,phone,email,status,createdAt,rejectionReason,reviewedAt,emailVerified);

@override
String toString() {
  return 'SignupRequest(id: $id, authUserId: $authUserId, businessName: $businessName, fullName: $fullName, phone: $phone, email: $email, status: $status, createdAt: $createdAt, rejectionReason: $rejectionReason, reviewedAt: $reviewedAt, emailVerified: $emailVerified)';
}


}

/// @nodoc
abstract mixin class _$SignupRequestCopyWith<$Res> implements $SignupRequestCopyWith<$Res> {
  factory _$SignupRequestCopyWith(_SignupRequest value, $Res Function(_SignupRequest) _then) = __$SignupRequestCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'auth_user_id') String authUserId,@JsonKey(name: 'business_name') String businessName,@JsonKey(name: 'full_name') String fullName, String phone, String email, SignupRequestStatus status,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'rejection_reason') String? rejectionReason,@JsonKey(name: 'reviewed_at') DateTime? reviewedAt,@JsonKey(name: 'email_verified') bool emailVerified
});




}
/// @nodoc
class __$SignupRequestCopyWithImpl<$Res>
    implements _$SignupRequestCopyWith<$Res> {
  __$SignupRequestCopyWithImpl(this._self, this._then);

  final _SignupRequest _self;
  final $Res Function(_SignupRequest) _then;

/// Create a copy of SignupRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? authUserId = null,Object? businessName = null,Object? fullName = null,Object? phone = null,Object? email = null,Object? status = null,Object? createdAt = null,Object? rejectionReason = freezed,Object? reviewedAt = freezed,Object? emailVerified = null,}) {
  return _then(_SignupRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,authUserId: null == authUserId ? _self.authUserId : authUserId // ignore: cast_nullable_to_non_nullable
as String,businessName: null == businessName ? _self.businessName : businessName // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SignupRequestStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,reviewedAt: freezed == reviewedAt ? _self.reviewedAt : reviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,emailVerified: null == emailVerified ? _self.emailVerified : emailVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
