// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shop.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Shop {

 String get id;@JsonKey(name: 'area_id') String get areaId;@JsonKey(name: 'shop_name') String get shopName;@JsonKey(name: 'shop_address') String get shopAddress;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'shop_number') String? get shopNumber;@JsonKey(name: 'shop_owner') String? get shopOwner;@JsonKey(name: 'phone_no') String? get phoneNo; String? get gstin;
/// Create a copy of Shop
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShopCopyWith<Shop> get copyWith => _$ShopCopyWithImpl<Shop>(this as Shop, _$identity);

  /// Serializes this Shop to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Shop&&(identical(other.id, id) || other.id == id)&&(identical(other.areaId, areaId) || other.areaId == areaId)&&(identical(other.shopName, shopName) || other.shopName == shopName)&&(identical(other.shopAddress, shopAddress) || other.shopAddress == shopAddress)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.shopNumber, shopNumber) || other.shopNumber == shopNumber)&&(identical(other.shopOwner, shopOwner) || other.shopOwner == shopOwner)&&(identical(other.phoneNo, phoneNo) || other.phoneNo == phoneNo)&&(identical(other.gstin, gstin) || other.gstin == gstin));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,areaId,shopName,shopAddress,createdAt,shopNumber,shopOwner,phoneNo,gstin);

@override
String toString() {
  return 'Shop(id: $id, areaId: $areaId, shopName: $shopName, shopAddress: $shopAddress, createdAt: $createdAt, shopNumber: $shopNumber, shopOwner: $shopOwner, phoneNo: $phoneNo, gstin: $gstin)';
}


}

/// @nodoc
abstract mixin class $ShopCopyWith<$Res>  {
  factory $ShopCopyWith(Shop value, $Res Function(Shop) _then) = _$ShopCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'area_id') String areaId,@JsonKey(name: 'shop_name') String shopName,@JsonKey(name: 'shop_address') String shopAddress,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'shop_number') String? shopNumber,@JsonKey(name: 'shop_owner') String? shopOwner,@JsonKey(name: 'phone_no') String? phoneNo, String? gstin
});




}
/// @nodoc
class _$ShopCopyWithImpl<$Res>
    implements $ShopCopyWith<$Res> {
  _$ShopCopyWithImpl(this._self, this._then);

  final Shop _self;
  final $Res Function(Shop) _then;

/// Create a copy of Shop
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? areaId = null,Object? shopName = null,Object? shopAddress = null,Object? createdAt = null,Object? shopNumber = freezed,Object? shopOwner = freezed,Object? phoneNo = freezed,Object? gstin = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,areaId: null == areaId ? _self.areaId : areaId // ignore: cast_nullable_to_non_nullable
as String,shopName: null == shopName ? _self.shopName : shopName // ignore: cast_nullable_to_non_nullable
as String,shopAddress: null == shopAddress ? _self.shopAddress : shopAddress // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,shopNumber: freezed == shopNumber ? _self.shopNumber : shopNumber // ignore: cast_nullable_to_non_nullable
as String?,shopOwner: freezed == shopOwner ? _self.shopOwner : shopOwner // ignore: cast_nullable_to_non_nullable
as String?,phoneNo: freezed == phoneNo ? _self.phoneNo : phoneNo // ignore: cast_nullable_to_non_nullable
as String?,gstin: freezed == gstin ? _self.gstin : gstin // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Shop].
extension ShopPatterns on Shop {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Shop value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Shop() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Shop value)  $default,){
final _that = this;
switch (_that) {
case _Shop():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Shop value)?  $default,){
final _that = this;
switch (_that) {
case _Shop() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'area_id')  String areaId, @JsonKey(name: 'shop_name')  String shopName, @JsonKey(name: 'shop_address')  String shopAddress, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'shop_number')  String? shopNumber, @JsonKey(name: 'shop_owner')  String? shopOwner, @JsonKey(name: 'phone_no')  String? phoneNo,  String? gstin)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Shop() when $default != null:
return $default(_that.id,_that.areaId,_that.shopName,_that.shopAddress,_that.createdAt,_that.shopNumber,_that.shopOwner,_that.phoneNo,_that.gstin);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'area_id')  String areaId, @JsonKey(name: 'shop_name')  String shopName, @JsonKey(name: 'shop_address')  String shopAddress, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'shop_number')  String? shopNumber, @JsonKey(name: 'shop_owner')  String? shopOwner, @JsonKey(name: 'phone_no')  String? phoneNo,  String? gstin)  $default,) {final _that = this;
switch (_that) {
case _Shop():
return $default(_that.id,_that.areaId,_that.shopName,_that.shopAddress,_that.createdAt,_that.shopNumber,_that.shopOwner,_that.phoneNo,_that.gstin);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'area_id')  String areaId, @JsonKey(name: 'shop_name')  String shopName, @JsonKey(name: 'shop_address')  String shopAddress, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'shop_number')  String? shopNumber, @JsonKey(name: 'shop_owner')  String? shopOwner, @JsonKey(name: 'phone_no')  String? phoneNo,  String? gstin)?  $default,) {final _that = this;
switch (_that) {
case _Shop() when $default != null:
return $default(_that.id,_that.areaId,_that.shopName,_that.shopAddress,_that.createdAt,_that.shopNumber,_that.shopOwner,_that.phoneNo,_that.gstin);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Shop implements Shop {
  const _Shop({required this.id, @JsonKey(name: 'area_id') required this.areaId, @JsonKey(name: 'shop_name') required this.shopName, @JsonKey(name: 'shop_address') required this.shopAddress, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'shop_number') this.shopNumber, @JsonKey(name: 'shop_owner') this.shopOwner, @JsonKey(name: 'phone_no') this.phoneNo, this.gstin});
  factory _Shop.fromJson(Map<String, dynamic> json) => _$ShopFromJson(json);

@override final  String id;
@override@JsonKey(name: 'area_id') final  String areaId;
@override@JsonKey(name: 'shop_name') final  String shopName;
@override@JsonKey(name: 'shop_address') final  String shopAddress;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'shop_number') final  String? shopNumber;
@override@JsonKey(name: 'shop_owner') final  String? shopOwner;
@override@JsonKey(name: 'phone_no') final  String? phoneNo;
@override final  String? gstin;

/// Create a copy of Shop
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShopCopyWith<_Shop> get copyWith => __$ShopCopyWithImpl<_Shop>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShopToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Shop&&(identical(other.id, id) || other.id == id)&&(identical(other.areaId, areaId) || other.areaId == areaId)&&(identical(other.shopName, shopName) || other.shopName == shopName)&&(identical(other.shopAddress, shopAddress) || other.shopAddress == shopAddress)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.shopNumber, shopNumber) || other.shopNumber == shopNumber)&&(identical(other.shopOwner, shopOwner) || other.shopOwner == shopOwner)&&(identical(other.phoneNo, phoneNo) || other.phoneNo == phoneNo)&&(identical(other.gstin, gstin) || other.gstin == gstin));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,areaId,shopName,shopAddress,createdAt,shopNumber,shopOwner,phoneNo,gstin);

@override
String toString() {
  return 'Shop(id: $id, areaId: $areaId, shopName: $shopName, shopAddress: $shopAddress, createdAt: $createdAt, shopNumber: $shopNumber, shopOwner: $shopOwner, phoneNo: $phoneNo, gstin: $gstin)';
}


}

/// @nodoc
abstract mixin class _$ShopCopyWith<$Res> implements $ShopCopyWith<$Res> {
  factory _$ShopCopyWith(_Shop value, $Res Function(_Shop) _then) = __$ShopCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'area_id') String areaId,@JsonKey(name: 'shop_name') String shopName,@JsonKey(name: 'shop_address') String shopAddress,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'shop_number') String? shopNumber,@JsonKey(name: 'shop_owner') String? shopOwner,@JsonKey(name: 'phone_no') String? phoneNo, String? gstin
});




}
/// @nodoc
class __$ShopCopyWithImpl<$Res>
    implements _$ShopCopyWith<$Res> {
  __$ShopCopyWithImpl(this._self, this._then);

  final _Shop _self;
  final $Res Function(_Shop) _then;

/// Create a copy of Shop
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? areaId = null,Object? shopName = null,Object? shopAddress = null,Object? createdAt = null,Object? shopNumber = freezed,Object? shopOwner = freezed,Object? phoneNo = freezed,Object? gstin = freezed,}) {
  return _then(_Shop(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,areaId: null == areaId ? _self.areaId : areaId // ignore: cast_nullable_to_non_nullable
as String,shopName: null == shopName ? _self.shopName : shopName // ignore: cast_nullable_to_non_nullable
as String,shopAddress: null == shopAddress ? _self.shopAddress : shopAddress // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,shopNumber: freezed == shopNumber ? _self.shopNumber : shopNumber // ignore: cast_nullable_to_non_nullable
as String?,shopOwner: freezed == shopOwner ? _self.shopOwner : shopOwner // ignore: cast_nullable_to_non_nullable
as String?,phoneNo: freezed == phoneNo ? _self.phoneNo : phoneNo // ignore: cast_nullable_to_non_nullable
as String?,gstin: freezed == gstin ? _self.gstin : gstin // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
