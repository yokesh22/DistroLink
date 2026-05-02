// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrderItem {

 String get id;@JsonKey(name: 'order_id') String get orderId;@JsonKey(name: 'product_id') String get productId;@JsonKey(name: 'item_code') String get itemCode;@JsonKey(name: 'item_name') String get itemName; double get mrp;@JsonKey(name: 'selling_rate') double get sellingRate; int get quantity;@JsonKey(name: 'gst_percent') double get gstPercent;@JsonKey(name: 'line_total') double get lineTotal;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of OrderItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderItemCopyWith<OrderItem> get copyWith => _$OrderItemCopyWithImpl<OrderItem>(this as OrderItem, _$identity);

  /// Serializes this OrderItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderItem&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.itemCode, itemCode) || other.itemCode == itemCode)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.mrp, mrp) || other.mrp == mrp)&&(identical(other.sellingRate, sellingRate) || other.sellingRate == sellingRate)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.gstPercent, gstPercent) || other.gstPercent == gstPercent)&&(identical(other.lineTotal, lineTotal) || other.lineTotal == lineTotal)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderId,productId,itemCode,itemName,mrp,sellingRate,quantity,gstPercent,lineTotal,createdAt);

@override
String toString() {
  return 'OrderItem(id: $id, orderId: $orderId, productId: $productId, itemCode: $itemCode, itemName: $itemName, mrp: $mrp, sellingRate: $sellingRate, quantity: $quantity, gstPercent: $gstPercent, lineTotal: $lineTotal, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $OrderItemCopyWith<$Res>  {
  factory $OrderItemCopyWith(OrderItem value, $Res Function(OrderItem) _then) = _$OrderItemCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'order_id') String orderId,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'item_code') String itemCode,@JsonKey(name: 'item_name') String itemName, double mrp,@JsonKey(name: 'selling_rate') double sellingRate, int quantity,@JsonKey(name: 'gst_percent') double gstPercent,@JsonKey(name: 'line_total') double lineTotal,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$OrderItemCopyWithImpl<$Res>
    implements $OrderItemCopyWith<$Res> {
  _$OrderItemCopyWithImpl(this._self, this._then);

  final OrderItem _self;
  final $Res Function(OrderItem) _then;

/// Create a copy of OrderItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orderId = null,Object? productId = null,Object? itemCode = null,Object? itemName = null,Object? mrp = null,Object? sellingRate = null,Object? quantity = null,Object? gstPercent = null,Object? lineTotal = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,itemCode: null == itemCode ? _self.itemCode : itemCode // ignore: cast_nullable_to_non_nullable
as String,itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,mrp: null == mrp ? _self.mrp : mrp // ignore: cast_nullable_to_non_nullable
as double,sellingRate: null == sellingRate ? _self.sellingRate : sellingRate // ignore: cast_nullable_to_non_nullable
as double,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,gstPercent: null == gstPercent ? _self.gstPercent : gstPercent // ignore: cast_nullable_to_non_nullable
as double,lineTotal: null == lineTotal ? _self.lineTotal : lineTotal // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderItem].
extension OrderItemPatterns on OrderItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderItem value)  $default,){
final _that = this;
switch (_that) {
case _OrderItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderItem value)?  $default,){
final _that = this;
switch (_that) {
case _OrderItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'order_id')  String orderId, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'item_code')  String itemCode, @JsonKey(name: 'item_name')  String itemName,  double mrp, @JsonKey(name: 'selling_rate')  double sellingRate,  int quantity, @JsonKey(name: 'gst_percent')  double gstPercent, @JsonKey(name: 'line_total')  double lineTotal, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderItem() when $default != null:
return $default(_that.id,_that.orderId,_that.productId,_that.itemCode,_that.itemName,_that.mrp,_that.sellingRate,_that.quantity,_that.gstPercent,_that.lineTotal,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'order_id')  String orderId, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'item_code')  String itemCode, @JsonKey(name: 'item_name')  String itemName,  double mrp, @JsonKey(name: 'selling_rate')  double sellingRate,  int quantity, @JsonKey(name: 'gst_percent')  double gstPercent, @JsonKey(name: 'line_total')  double lineTotal, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _OrderItem():
return $default(_that.id,_that.orderId,_that.productId,_that.itemCode,_that.itemName,_that.mrp,_that.sellingRate,_that.quantity,_that.gstPercent,_that.lineTotal,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'order_id')  String orderId, @JsonKey(name: 'product_id')  String productId, @JsonKey(name: 'item_code')  String itemCode, @JsonKey(name: 'item_name')  String itemName,  double mrp, @JsonKey(name: 'selling_rate')  double sellingRate,  int quantity, @JsonKey(name: 'gst_percent')  double gstPercent, @JsonKey(name: 'line_total')  double lineTotal, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _OrderItem() when $default != null:
return $default(_that.id,_that.orderId,_that.productId,_that.itemCode,_that.itemName,_that.mrp,_that.sellingRate,_that.quantity,_that.gstPercent,_that.lineTotal,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderItem implements OrderItem {
  const _OrderItem({required this.id, @JsonKey(name: 'order_id') required this.orderId, @JsonKey(name: 'product_id') required this.productId, @JsonKey(name: 'item_code') required this.itemCode, @JsonKey(name: 'item_name') required this.itemName, required this.mrp, @JsonKey(name: 'selling_rate') required this.sellingRate, required this.quantity, @JsonKey(name: 'gst_percent') required this.gstPercent, @JsonKey(name: 'line_total') required this.lineTotal, @JsonKey(name: 'created_at') required this.createdAt});
  factory _OrderItem.fromJson(Map<String, dynamic> json) => _$OrderItemFromJson(json);

@override final  String id;
@override@JsonKey(name: 'order_id') final  String orderId;
@override@JsonKey(name: 'product_id') final  String productId;
@override@JsonKey(name: 'item_code') final  String itemCode;
@override@JsonKey(name: 'item_name') final  String itemName;
@override final  double mrp;
@override@JsonKey(name: 'selling_rate') final  double sellingRate;
@override final  int quantity;
@override@JsonKey(name: 'gst_percent') final  double gstPercent;
@override@JsonKey(name: 'line_total') final  double lineTotal;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of OrderItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderItemCopyWith<_OrderItem> get copyWith => __$OrderItemCopyWithImpl<_OrderItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderItem&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.itemCode, itemCode) || other.itemCode == itemCode)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.mrp, mrp) || other.mrp == mrp)&&(identical(other.sellingRate, sellingRate) || other.sellingRate == sellingRate)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.gstPercent, gstPercent) || other.gstPercent == gstPercent)&&(identical(other.lineTotal, lineTotal) || other.lineTotal == lineTotal)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderId,productId,itemCode,itemName,mrp,sellingRate,quantity,gstPercent,lineTotal,createdAt);

@override
String toString() {
  return 'OrderItem(id: $id, orderId: $orderId, productId: $productId, itemCode: $itemCode, itemName: $itemName, mrp: $mrp, sellingRate: $sellingRate, quantity: $quantity, gstPercent: $gstPercent, lineTotal: $lineTotal, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$OrderItemCopyWith<$Res> implements $OrderItemCopyWith<$Res> {
  factory _$OrderItemCopyWith(_OrderItem value, $Res Function(_OrderItem) _then) = __$OrderItemCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'order_id') String orderId,@JsonKey(name: 'product_id') String productId,@JsonKey(name: 'item_code') String itemCode,@JsonKey(name: 'item_name') String itemName, double mrp,@JsonKey(name: 'selling_rate') double sellingRate, int quantity,@JsonKey(name: 'gst_percent') double gstPercent,@JsonKey(name: 'line_total') double lineTotal,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$OrderItemCopyWithImpl<$Res>
    implements _$OrderItemCopyWith<$Res> {
  __$OrderItemCopyWithImpl(this._self, this._then);

  final _OrderItem _self;
  final $Res Function(_OrderItem) _then;

/// Create a copy of OrderItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orderId = null,Object? productId = null,Object? itemCode = null,Object? itemName = null,Object? mrp = null,Object? sellingRate = null,Object? quantity = null,Object? gstPercent = null,Object? lineTotal = null,Object? createdAt = null,}) {
  return _then(_OrderItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,itemCode: null == itemCode ? _self.itemCode : itemCode // ignore: cast_nullable_to_non_nullable
as String,itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,mrp: null == mrp ? _self.mrp : mrp // ignore: cast_nullable_to_non_nullable
as double,sellingRate: null == sellingRate ? _self.sellingRate : sellingRate // ignore: cast_nullable_to_non_nullable
as double,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,gstPercent: null == gstPercent ? _self.gstPercent : gstPercent // ignore: cast_nullable_to_non_nullable
as double,lineTotal: null == lineTotal ? _self.lineTotal : lineTotal // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
