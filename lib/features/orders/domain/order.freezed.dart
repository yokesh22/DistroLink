// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Order {

 String get id;@JsonKey(name: 'order_number') String get orderNumber;@JsonKey(name: 'distributor_id') String get distributorId;@JsonKey(name: 'salesman_id') String get salesmanId;@JsonKey(name: 'shop_id') String get shopId;@JsonKey(name: 'area_id') String get areaId; double get subtotal;@JsonKey(name: 'gst_total') double get gstTotal;@JsonKey(name: 'grand_total') double get grandTotal;@JsonKey(name: 'order_date') DateTime get orderDate;@JsonKey(name: 'created_at') DateTime get createdAt;// Optional fields
 String? get notes;// Joined from shops
@JsonKey(name: 'shop_name') String? get shopName;@JsonKey(name: 'shop_number') String? get shopNumber;@JsonKey(name: 'shop_address') String? get shopAddress;// Joined from areas
@JsonKey(name: 'area_name') String? get areaName;// Joined from salesmen
@JsonKey(name: 'salesman_name') String? get salesmanName;@JsonKey(name: 'salesman_phone') String? get salesmanPhone;// Joined from distributors
@JsonKey(name: 'distributor_name') String? get distributorName;@JsonKey(name: 'distributor_phone') String? get distributorPhone;@JsonKey(name: 'distributor_email') String? get distributorEmail;
/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderCopyWith<Order> get copyWith => _$OrderCopyWithImpl<Order>(this as Order, _$identity);

  /// Serializes this Order to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Order&&(identical(other.id, id) || other.id == id)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.distributorId, distributorId) || other.distributorId == distributorId)&&(identical(other.salesmanId, salesmanId) || other.salesmanId == salesmanId)&&(identical(other.shopId, shopId) || other.shopId == shopId)&&(identical(other.areaId, areaId) || other.areaId == areaId)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.gstTotal, gstTotal) || other.gstTotal == gstTotal)&&(identical(other.grandTotal, grandTotal) || other.grandTotal == grandTotal)&&(identical(other.orderDate, orderDate) || other.orderDate == orderDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.shopName, shopName) || other.shopName == shopName)&&(identical(other.shopNumber, shopNumber) || other.shopNumber == shopNumber)&&(identical(other.shopAddress, shopAddress) || other.shopAddress == shopAddress)&&(identical(other.areaName, areaName) || other.areaName == areaName)&&(identical(other.salesmanName, salesmanName) || other.salesmanName == salesmanName)&&(identical(other.salesmanPhone, salesmanPhone) || other.salesmanPhone == salesmanPhone)&&(identical(other.distributorName, distributorName) || other.distributorName == distributorName)&&(identical(other.distributorPhone, distributorPhone) || other.distributorPhone == distributorPhone)&&(identical(other.distributorEmail, distributorEmail) || other.distributorEmail == distributorEmail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,orderNumber,distributorId,salesmanId,shopId,areaId,subtotal,gstTotal,grandTotal,orderDate,createdAt,notes,shopName,shopNumber,shopAddress,areaName,salesmanName,salesmanPhone,distributorName,distributorPhone,distributorEmail]);

@override
String toString() {
  return 'Order(id: $id, orderNumber: $orderNumber, distributorId: $distributorId, salesmanId: $salesmanId, shopId: $shopId, areaId: $areaId, subtotal: $subtotal, gstTotal: $gstTotal, grandTotal: $grandTotal, orderDate: $orderDate, createdAt: $createdAt, notes: $notes, shopName: $shopName, shopNumber: $shopNumber, shopAddress: $shopAddress, areaName: $areaName, salesmanName: $salesmanName, salesmanPhone: $salesmanPhone, distributorName: $distributorName, distributorPhone: $distributorPhone, distributorEmail: $distributorEmail)';
}


}

/// @nodoc
abstract mixin class $OrderCopyWith<$Res>  {
  factory $OrderCopyWith(Order value, $Res Function(Order) _then) = _$OrderCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'order_number') String orderNumber,@JsonKey(name: 'distributor_id') String distributorId,@JsonKey(name: 'salesman_id') String salesmanId,@JsonKey(name: 'shop_id') String shopId,@JsonKey(name: 'area_id') String areaId, double subtotal,@JsonKey(name: 'gst_total') double gstTotal,@JsonKey(name: 'grand_total') double grandTotal,@JsonKey(name: 'order_date') DateTime orderDate,@JsonKey(name: 'created_at') DateTime createdAt, String? notes,@JsonKey(name: 'shop_name') String? shopName,@JsonKey(name: 'shop_number') String? shopNumber,@JsonKey(name: 'shop_address') String? shopAddress,@JsonKey(name: 'area_name') String? areaName,@JsonKey(name: 'salesman_name') String? salesmanName,@JsonKey(name: 'salesman_phone') String? salesmanPhone,@JsonKey(name: 'distributor_name') String? distributorName,@JsonKey(name: 'distributor_phone') String? distributorPhone,@JsonKey(name: 'distributor_email') String? distributorEmail
});




}
/// @nodoc
class _$OrderCopyWithImpl<$Res>
    implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._self, this._then);

  final Order _self;
  final $Res Function(Order) _then;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orderNumber = null,Object? distributorId = null,Object? salesmanId = null,Object? shopId = null,Object? areaId = null,Object? subtotal = null,Object? gstTotal = null,Object? grandTotal = null,Object? orderDate = null,Object? createdAt = null,Object? notes = freezed,Object? shopName = freezed,Object? shopNumber = freezed,Object? shopAddress = freezed,Object? areaName = freezed,Object? salesmanName = freezed,Object? salesmanPhone = freezed,Object? distributorName = freezed,Object? distributorPhone = freezed,Object? distributorEmail = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,distributorId: null == distributorId ? _self.distributorId : distributorId // ignore: cast_nullable_to_non_nullable
as String,salesmanId: null == salesmanId ? _self.salesmanId : salesmanId // ignore: cast_nullable_to_non_nullable
as String,shopId: null == shopId ? _self.shopId : shopId // ignore: cast_nullable_to_non_nullable
as String,areaId: null == areaId ? _self.areaId : areaId // ignore: cast_nullable_to_non_nullable
as String,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,gstTotal: null == gstTotal ? _self.gstTotal : gstTotal // ignore: cast_nullable_to_non_nullable
as double,grandTotal: null == grandTotal ? _self.grandTotal : grandTotal // ignore: cast_nullable_to_non_nullable
as double,orderDate: null == orderDate ? _self.orderDate : orderDate // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,shopName: freezed == shopName ? _self.shopName : shopName // ignore: cast_nullable_to_non_nullable
as String?,shopNumber: freezed == shopNumber ? _self.shopNumber : shopNumber // ignore: cast_nullable_to_non_nullable
as String?,shopAddress: freezed == shopAddress ? _self.shopAddress : shopAddress // ignore: cast_nullable_to_non_nullable
as String?,areaName: freezed == areaName ? _self.areaName : areaName // ignore: cast_nullable_to_non_nullable
as String?,salesmanName: freezed == salesmanName ? _self.salesmanName : salesmanName // ignore: cast_nullable_to_non_nullable
as String?,salesmanPhone: freezed == salesmanPhone ? _self.salesmanPhone : salesmanPhone // ignore: cast_nullable_to_non_nullable
as String?,distributorName: freezed == distributorName ? _self.distributorName : distributorName // ignore: cast_nullable_to_non_nullable
as String?,distributorPhone: freezed == distributorPhone ? _self.distributorPhone : distributorPhone // ignore: cast_nullable_to_non_nullable
as String?,distributorEmail: freezed == distributorEmail ? _self.distributorEmail : distributorEmail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Order].
extension OrderPatterns on Order {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Order value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Order() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Order value)  $default,){
final _that = this;
switch (_that) {
case _Order():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Order value)?  $default,){
final _that = this;
switch (_that) {
case _Order() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'order_number')  String orderNumber, @JsonKey(name: 'distributor_id')  String distributorId, @JsonKey(name: 'salesman_id')  String salesmanId, @JsonKey(name: 'shop_id')  String shopId, @JsonKey(name: 'area_id')  String areaId,  double subtotal, @JsonKey(name: 'gst_total')  double gstTotal, @JsonKey(name: 'grand_total')  double grandTotal, @JsonKey(name: 'order_date')  DateTime orderDate, @JsonKey(name: 'created_at')  DateTime createdAt,  String? notes, @JsonKey(name: 'shop_name')  String? shopName, @JsonKey(name: 'shop_number')  String? shopNumber, @JsonKey(name: 'shop_address')  String? shopAddress, @JsonKey(name: 'area_name')  String? areaName, @JsonKey(name: 'salesman_name')  String? salesmanName, @JsonKey(name: 'salesman_phone')  String? salesmanPhone, @JsonKey(name: 'distributor_name')  String? distributorName, @JsonKey(name: 'distributor_phone')  String? distributorPhone, @JsonKey(name: 'distributor_email')  String? distributorEmail)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.orderNumber,_that.distributorId,_that.salesmanId,_that.shopId,_that.areaId,_that.subtotal,_that.gstTotal,_that.grandTotal,_that.orderDate,_that.createdAt,_that.notes,_that.shopName,_that.shopNumber,_that.shopAddress,_that.areaName,_that.salesmanName,_that.salesmanPhone,_that.distributorName,_that.distributorPhone,_that.distributorEmail);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'order_number')  String orderNumber, @JsonKey(name: 'distributor_id')  String distributorId, @JsonKey(name: 'salesman_id')  String salesmanId, @JsonKey(name: 'shop_id')  String shopId, @JsonKey(name: 'area_id')  String areaId,  double subtotal, @JsonKey(name: 'gst_total')  double gstTotal, @JsonKey(name: 'grand_total')  double grandTotal, @JsonKey(name: 'order_date')  DateTime orderDate, @JsonKey(name: 'created_at')  DateTime createdAt,  String? notes, @JsonKey(name: 'shop_name')  String? shopName, @JsonKey(name: 'shop_number')  String? shopNumber, @JsonKey(name: 'shop_address')  String? shopAddress, @JsonKey(name: 'area_name')  String? areaName, @JsonKey(name: 'salesman_name')  String? salesmanName, @JsonKey(name: 'salesman_phone')  String? salesmanPhone, @JsonKey(name: 'distributor_name')  String? distributorName, @JsonKey(name: 'distributor_phone')  String? distributorPhone, @JsonKey(name: 'distributor_email')  String? distributorEmail)  $default,) {final _that = this;
switch (_that) {
case _Order():
return $default(_that.id,_that.orderNumber,_that.distributorId,_that.salesmanId,_that.shopId,_that.areaId,_that.subtotal,_that.gstTotal,_that.grandTotal,_that.orderDate,_that.createdAt,_that.notes,_that.shopName,_that.shopNumber,_that.shopAddress,_that.areaName,_that.salesmanName,_that.salesmanPhone,_that.distributorName,_that.distributorPhone,_that.distributorEmail);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'order_number')  String orderNumber, @JsonKey(name: 'distributor_id')  String distributorId, @JsonKey(name: 'salesman_id')  String salesmanId, @JsonKey(name: 'shop_id')  String shopId, @JsonKey(name: 'area_id')  String areaId,  double subtotal, @JsonKey(name: 'gst_total')  double gstTotal, @JsonKey(name: 'grand_total')  double grandTotal, @JsonKey(name: 'order_date')  DateTime orderDate, @JsonKey(name: 'created_at')  DateTime createdAt,  String? notes, @JsonKey(name: 'shop_name')  String? shopName, @JsonKey(name: 'shop_number')  String? shopNumber, @JsonKey(name: 'shop_address')  String? shopAddress, @JsonKey(name: 'area_name')  String? areaName, @JsonKey(name: 'salesman_name')  String? salesmanName, @JsonKey(name: 'salesman_phone')  String? salesmanPhone, @JsonKey(name: 'distributor_name')  String? distributorName, @JsonKey(name: 'distributor_phone')  String? distributorPhone, @JsonKey(name: 'distributor_email')  String? distributorEmail)?  $default,) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.orderNumber,_that.distributorId,_that.salesmanId,_that.shopId,_that.areaId,_that.subtotal,_that.gstTotal,_that.grandTotal,_that.orderDate,_that.createdAt,_that.notes,_that.shopName,_that.shopNumber,_that.shopAddress,_that.areaName,_that.salesmanName,_that.salesmanPhone,_that.distributorName,_that.distributorPhone,_that.distributorEmail);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Order implements Order {
  const _Order({required this.id, @JsonKey(name: 'order_number') required this.orderNumber, @JsonKey(name: 'distributor_id') required this.distributorId, @JsonKey(name: 'salesman_id') required this.salesmanId, @JsonKey(name: 'shop_id') required this.shopId, @JsonKey(name: 'area_id') required this.areaId, required this.subtotal, @JsonKey(name: 'gst_total') required this.gstTotal, @JsonKey(name: 'grand_total') required this.grandTotal, @JsonKey(name: 'order_date') required this.orderDate, @JsonKey(name: 'created_at') required this.createdAt, this.notes, @JsonKey(name: 'shop_name') this.shopName, @JsonKey(name: 'shop_number') this.shopNumber, @JsonKey(name: 'shop_address') this.shopAddress, @JsonKey(name: 'area_name') this.areaName, @JsonKey(name: 'salesman_name') this.salesmanName, @JsonKey(name: 'salesman_phone') this.salesmanPhone, @JsonKey(name: 'distributor_name') this.distributorName, @JsonKey(name: 'distributor_phone') this.distributorPhone, @JsonKey(name: 'distributor_email') this.distributorEmail});
  factory _Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

@override final  String id;
@override@JsonKey(name: 'order_number') final  String orderNumber;
@override@JsonKey(name: 'distributor_id') final  String distributorId;
@override@JsonKey(name: 'salesman_id') final  String salesmanId;
@override@JsonKey(name: 'shop_id') final  String shopId;
@override@JsonKey(name: 'area_id') final  String areaId;
@override final  double subtotal;
@override@JsonKey(name: 'gst_total') final  double gstTotal;
@override@JsonKey(name: 'grand_total') final  double grandTotal;
@override@JsonKey(name: 'order_date') final  DateTime orderDate;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
// Optional fields
@override final  String? notes;
// Joined from shops
@override@JsonKey(name: 'shop_name') final  String? shopName;
@override@JsonKey(name: 'shop_number') final  String? shopNumber;
@override@JsonKey(name: 'shop_address') final  String? shopAddress;
// Joined from areas
@override@JsonKey(name: 'area_name') final  String? areaName;
// Joined from salesmen
@override@JsonKey(name: 'salesman_name') final  String? salesmanName;
@override@JsonKey(name: 'salesman_phone') final  String? salesmanPhone;
// Joined from distributors
@override@JsonKey(name: 'distributor_name') final  String? distributorName;
@override@JsonKey(name: 'distributor_phone') final  String? distributorPhone;
@override@JsonKey(name: 'distributor_email') final  String? distributorEmail;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderCopyWith<_Order> get copyWith => __$OrderCopyWithImpl<_Order>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Order&&(identical(other.id, id) || other.id == id)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.distributorId, distributorId) || other.distributorId == distributorId)&&(identical(other.salesmanId, salesmanId) || other.salesmanId == salesmanId)&&(identical(other.shopId, shopId) || other.shopId == shopId)&&(identical(other.areaId, areaId) || other.areaId == areaId)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.gstTotal, gstTotal) || other.gstTotal == gstTotal)&&(identical(other.grandTotal, grandTotal) || other.grandTotal == grandTotal)&&(identical(other.orderDate, orderDate) || other.orderDate == orderDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.shopName, shopName) || other.shopName == shopName)&&(identical(other.shopNumber, shopNumber) || other.shopNumber == shopNumber)&&(identical(other.shopAddress, shopAddress) || other.shopAddress == shopAddress)&&(identical(other.areaName, areaName) || other.areaName == areaName)&&(identical(other.salesmanName, salesmanName) || other.salesmanName == salesmanName)&&(identical(other.salesmanPhone, salesmanPhone) || other.salesmanPhone == salesmanPhone)&&(identical(other.distributorName, distributorName) || other.distributorName == distributorName)&&(identical(other.distributorPhone, distributorPhone) || other.distributorPhone == distributorPhone)&&(identical(other.distributorEmail, distributorEmail) || other.distributorEmail == distributorEmail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,orderNumber,distributorId,salesmanId,shopId,areaId,subtotal,gstTotal,grandTotal,orderDate,createdAt,notes,shopName,shopNumber,shopAddress,areaName,salesmanName,salesmanPhone,distributorName,distributorPhone,distributorEmail]);

@override
String toString() {
  return 'Order(id: $id, orderNumber: $orderNumber, distributorId: $distributorId, salesmanId: $salesmanId, shopId: $shopId, areaId: $areaId, subtotal: $subtotal, gstTotal: $gstTotal, grandTotal: $grandTotal, orderDate: $orderDate, createdAt: $createdAt, notes: $notes, shopName: $shopName, shopNumber: $shopNumber, shopAddress: $shopAddress, areaName: $areaName, salesmanName: $salesmanName, salesmanPhone: $salesmanPhone, distributorName: $distributorName, distributorPhone: $distributorPhone, distributorEmail: $distributorEmail)';
}


}

/// @nodoc
abstract mixin class _$OrderCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$OrderCopyWith(_Order value, $Res Function(_Order) _then) = __$OrderCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'order_number') String orderNumber,@JsonKey(name: 'distributor_id') String distributorId,@JsonKey(name: 'salesman_id') String salesmanId,@JsonKey(name: 'shop_id') String shopId,@JsonKey(name: 'area_id') String areaId, double subtotal,@JsonKey(name: 'gst_total') double gstTotal,@JsonKey(name: 'grand_total') double grandTotal,@JsonKey(name: 'order_date') DateTime orderDate,@JsonKey(name: 'created_at') DateTime createdAt, String? notes,@JsonKey(name: 'shop_name') String? shopName,@JsonKey(name: 'shop_number') String? shopNumber,@JsonKey(name: 'shop_address') String? shopAddress,@JsonKey(name: 'area_name') String? areaName,@JsonKey(name: 'salesman_name') String? salesmanName,@JsonKey(name: 'salesman_phone') String? salesmanPhone,@JsonKey(name: 'distributor_name') String? distributorName,@JsonKey(name: 'distributor_phone') String? distributorPhone,@JsonKey(name: 'distributor_email') String? distributorEmail
});




}
/// @nodoc
class __$OrderCopyWithImpl<$Res>
    implements _$OrderCopyWith<$Res> {
  __$OrderCopyWithImpl(this._self, this._then);

  final _Order _self;
  final $Res Function(_Order) _then;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orderNumber = null,Object? distributorId = null,Object? salesmanId = null,Object? shopId = null,Object? areaId = null,Object? subtotal = null,Object? gstTotal = null,Object? grandTotal = null,Object? orderDate = null,Object? createdAt = null,Object? notes = freezed,Object? shopName = freezed,Object? shopNumber = freezed,Object? shopAddress = freezed,Object? areaName = freezed,Object? salesmanName = freezed,Object? salesmanPhone = freezed,Object? distributorName = freezed,Object? distributorPhone = freezed,Object? distributorEmail = freezed,}) {
  return _then(_Order(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,distributorId: null == distributorId ? _self.distributorId : distributorId // ignore: cast_nullable_to_non_nullable
as String,salesmanId: null == salesmanId ? _self.salesmanId : salesmanId // ignore: cast_nullable_to_non_nullable
as String,shopId: null == shopId ? _self.shopId : shopId // ignore: cast_nullable_to_non_nullable
as String,areaId: null == areaId ? _self.areaId : areaId // ignore: cast_nullable_to_non_nullable
as String,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,gstTotal: null == gstTotal ? _self.gstTotal : gstTotal // ignore: cast_nullable_to_non_nullable
as double,grandTotal: null == grandTotal ? _self.grandTotal : grandTotal // ignore: cast_nullable_to_non_nullable
as double,orderDate: null == orderDate ? _self.orderDate : orderDate // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,shopName: freezed == shopName ? _self.shopName : shopName // ignore: cast_nullable_to_non_nullable
as String?,shopNumber: freezed == shopNumber ? _self.shopNumber : shopNumber // ignore: cast_nullable_to_non_nullable
as String?,shopAddress: freezed == shopAddress ? _self.shopAddress : shopAddress // ignore: cast_nullable_to_non_nullable
as String?,areaName: freezed == areaName ? _self.areaName : areaName // ignore: cast_nullable_to_non_nullable
as String?,salesmanName: freezed == salesmanName ? _self.salesmanName : salesmanName // ignore: cast_nullable_to_non_nullable
as String?,salesmanPhone: freezed == salesmanPhone ? _self.salesmanPhone : salesmanPhone // ignore: cast_nullable_to_non_nullable
as String?,distributorName: freezed == distributorName ? _self.distributorName : distributorName // ignore: cast_nullable_to_non_nullable
as String?,distributorPhone: freezed == distributorPhone ? _self.distributorPhone : distributorPhone // ignore: cast_nullable_to_non_nullable
as String?,distributorEmail: freezed == distributorEmail ? _self.distributorEmail : distributorEmail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
