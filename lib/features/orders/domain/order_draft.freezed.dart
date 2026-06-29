// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrderDraftState {

 Area? get area; Shop? get shop; DateTime? get orderDate; DateTime? get deliveryDate; OrderType get orderType; String get notes; List<DraftItem> get items;/// When non-null, this draft is editing an existing order (UPDATE) rather
/// than creating a new one (INSERT). Holds the `orders.id` being edited.
 String? get editingOrderId;
/// Create a copy of OrderDraftState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderDraftStateCopyWith<OrderDraftState> get copyWith => _$OrderDraftStateCopyWithImpl<OrderDraftState>(this as OrderDraftState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderDraftState&&(identical(other.area, area) || other.area == area)&&(identical(other.shop, shop) || other.shop == shop)&&(identical(other.orderDate, orderDate) || other.orderDate == orderDate)&&(identical(other.deliveryDate, deliveryDate) || other.deliveryDate == deliveryDate)&&(identical(other.orderType, orderType) || other.orderType == orderType)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.editingOrderId, editingOrderId) || other.editingOrderId == editingOrderId));
}


@override
int get hashCode => Object.hash(runtimeType,area,shop,orderDate,deliveryDate,orderType,notes,const DeepCollectionEquality().hash(items),editingOrderId);

@override
String toString() {
  return 'OrderDraftState(area: $area, shop: $shop, orderDate: $orderDate, deliveryDate: $deliveryDate, orderType: $orderType, notes: $notes, items: $items, editingOrderId: $editingOrderId)';
}


}

/// @nodoc
abstract mixin class $OrderDraftStateCopyWith<$Res>  {
  factory $OrderDraftStateCopyWith(OrderDraftState value, $Res Function(OrderDraftState) _then) = _$OrderDraftStateCopyWithImpl;
@useResult
$Res call({
 Area? area, Shop? shop, DateTime? orderDate, DateTime? deliveryDate, OrderType orderType, String notes, List<DraftItem> items, String? editingOrderId
});


$AreaCopyWith<$Res>? get area;$ShopCopyWith<$Res>? get shop;

}
/// @nodoc
class _$OrderDraftStateCopyWithImpl<$Res>
    implements $OrderDraftStateCopyWith<$Res> {
  _$OrderDraftStateCopyWithImpl(this._self, this._then);

  final OrderDraftState _self;
  final $Res Function(OrderDraftState) _then;

/// Create a copy of OrderDraftState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? area = freezed,Object? shop = freezed,Object? orderDate = freezed,Object? deliveryDate = freezed,Object? orderType = null,Object? notes = null,Object? items = null,Object? editingOrderId = freezed,}) {
  return _then(_self.copyWith(
area: freezed == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as Area?,shop: freezed == shop ? _self.shop : shop // ignore: cast_nullable_to_non_nullable
as Shop?,orderDate: freezed == orderDate ? _self.orderDate : orderDate // ignore: cast_nullable_to_non_nullable
as DateTime?,deliveryDate: freezed == deliveryDate ? _self.deliveryDate : deliveryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,orderType: null == orderType ? _self.orderType : orderType // ignore: cast_nullable_to_non_nullable
as OrderType,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<DraftItem>,editingOrderId: freezed == editingOrderId ? _self.editingOrderId : editingOrderId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of OrderDraftState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AreaCopyWith<$Res>? get area {
    if (_self.area == null) {
    return null;
  }

  return $AreaCopyWith<$Res>(_self.area!, (value) {
    return _then(_self.copyWith(area: value));
  });
}/// Create a copy of OrderDraftState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShopCopyWith<$Res>? get shop {
    if (_self.shop == null) {
    return null;
  }

  return $ShopCopyWith<$Res>(_self.shop!, (value) {
    return _then(_self.copyWith(shop: value));
  });
}
}


/// Adds pattern-matching-related methods to [OrderDraftState].
extension OrderDraftStatePatterns on OrderDraftState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderDraftState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderDraftState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderDraftState value)  $default,){
final _that = this;
switch (_that) {
case _OrderDraftState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderDraftState value)?  $default,){
final _that = this;
switch (_that) {
case _OrderDraftState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Area? area,  Shop? shop,  DateTime? orderDate,  DateTime? deliveryDate,  OrderType orderType,  String notes,  List<DraftItem> items,  String? editingOrderId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderDraftState() when $default != null:
return $default(_that.area,_that.shop,_that.orderDate,_that.deliveryDate,_that.orderType,_that.notes,_that.items,_that.editingOrderId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Area? area,  Shop? shop,  DateTime? orderDate,  DateTime? deliveryDate,  OrderType orderType,  String notes,  List<DraftItem> items,  String? editingOrderId)  $default,) {final _that = this;
switch (_that) {
case _OrderDraftState():
return $default(_that.area,_that.shop,_that.orderDate,_that.deliveryDate,_that.orderType,_that.notes,_that.items,_that.editingOrderId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Area? area,  Shop? shop,  DateTime? orderDate,  DateTime? deliveryDate,  OrderType orderType,  String notes,  List<DraftItem> items,  String? editingOrderId)?  $default,) {final _that = this;
switch (_that) {
case _OrderDraftState() when $default != null:
return $default(_that.area,_that.shop,_that.orderDate,_that.deliveryDate,_that.orderType,_that.notes,_that.items,_that.editingOrderId);case _:
  return null;

}
}

}

/// @nodoc


class _OrderDraftState extends OrderDraftState {
  const _OrderDraftState({this.area, this.shop, this.orderDate, this.deliveryDate, this.orderType = OrderType.regular, this.notes = '', final  List<DraftItem> items = const [], this.editingOrderId}): _items = items,super._();
  

@override final  Area? area;
@override final  Shop? shop;
@override final  DateTime? orderDate;
@override final  DateTime? deliveryDate;
@override@JsonKey() final  OrderType orderType;
@override@JsonKey() final  String notes;
 final  List<DraftItem> _items;
@override@JsonKey() List<DraftItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

/// When non-null, this draft is editing an existing order (UPDATE) rather
/// than creating a new one (INSERT). Holds the `orders.id` being edited.
@override final  String? editingOrderId;

/// Create a copy of OrderDraftState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderDraftStateCopyWith<_OrderDraftState> get copyWith => __$OrderDraftStateCopyWithImpl<_OrderDraftState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderDraftState&&(identical(other.area, area) || other.area == area)&&(identical(other.shop, shop) || other.shop == shop)&&(identical(other.orderDate, orderDate) || other.orderDate == orderDate)&&(identical(other.deliveryDate, deliveryDate) || other.deliveryDate == deliveryDate)&&(identical(other.orderType, orderType) || other.orderType == orderType)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.editingOrderId, editingOrderId) || other.editingOrderId == editingOrderId));
}


@override
int get hashCode => Object.hash(runtimeType,area,shop,orderDate,deliveryDate,orderType,notes,const DeepCollectionEquality().hash(_items),editingOrderId);

@override
String toString() {
  return 'OrderDraftState(area: $area, shop: $shop, orderDate: $orderDate, deliveryDate: $deliveryDate, orderType: $orderType, notes: $notes, items: $items, editingOrderId: $editingOrderId)';
}


}

/// @nodoc
abstract mixin class _$OrderDraftStateCopyWith<$Res> implements $OrderDraftStateCopyWith<$Res> {
  factory _$OrderDraftStateCopyWith(_OrderDraftState value, $Res Function(_OrderDraftState) _then) = __$OrderDraftStateCopyWithImpl;
@override @useResult
$Res call({
 Area? area, Shop? shop, DateTime? orderDate, DateTime? deliveryDate, OrderType orderType, String notes, List<DraftItem> items, String? editingOrderId
});


@override $AreaCopyWith<$Res>? get area;@override $ShopCopyWith<$Res>? get shop;

}
/// @nodoc
class __$OrderDraftStateCopyWithImpl<$Res>
    implements _$OrderDraftStateCopyWith<$Res> {
  __$OrderDraftStateCopyWithImpl(this._self, this._then);

  final _OrderDraftState _self;
  final $Res Function(_OrderDraftState) _then;

/// Create a copy of OrderDraftState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? area = freezed,Object? shop = freezed,Object? orderDate = freezed,Object? deliveryDate = freezed,Object? orderType = null,Object? notes = null,Object? items = null,Object? editingOrderId = freezed,}) {
  return _then(_OrderDraftState(
area: freezed == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as Area?,shop: freezed == shop ? _self.shop : shop // ignore: cast_nullable_to_non_nullable
as Shop?,orderDate: freezed == orderDate ? _self.orderDate : orderDate // ignore: cast_nullable_to_non_nullable
as DateTime?,deliveryDate: freezed == deliveryDate ? _self.deliveryDate : deliveryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,orderType: null == orderType ? _self.orderType : orderType // ignore: cast_nullable_to_non_nullable
as OrderType,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<DraftItem>,editingOrderId: freezed == editingOrderId ? _self.editingOrderId : editingOrderId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of OrderDraftState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AreaCopyWith<$Res>? get area {
    if (_self.area == null) {
    return null;
  }

  return $AreaCopyWith<$Res>(_self.area!, (value) {
    return _then(_self.copyWith(area: value));
  });
}/// Create a copy of OrderDraftState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShopCopyWith<$Res>? get shop {
    if (_self.shop == null) {
    return null;
  }

  return $ShopCopyWith<$Res>(_self.shop!, (value) {
    return _then(_self.copyWith(shop: value));
  });
}
}

/// @nodoc
mixin _$DraftItem {

 String get productId; String get itemCode; String get itemName; double get mrp; double get baseRate; double get sellingRate; int get quantity; double get gstPercent; double get discountPercent; int get freeQty;
/// Create a copy of DraftItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DraftItemCopyWith<DraftItem> get copyWith => _$DraftItemCopyWithImpl<DraftItem>(this as DraftItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DraftItem&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.itemCode, itemCode) || other.itemCode == itemCode)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.mrp, mrp) || other.mrp == mrp)&&(identical(other.baseRate, baseRate) || other.baseRate == baseRate)&&(identical(other.sellingRate, sellingRate) || other.sellingRate == sellingRate)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.gstPercent, gstPercent) || other.gstPercent == gstPercent)&&(identical(other.discountPercent, discountPercent) || other.discountPercent == discountPercent)&&(identical(other.freeQty, freeQty) || other.freeQty == freeQty));
}


@override
int get hashCode => Object.hash(runtimeType,productId,itemCode,itemName,mrp,baseRate,sellingRate,quantity,gstPercent,discountPercent,freeQty);

@override
String toString() {
  return 'DraftItem(productId: $productId, itemCode: $itemCode, itemName: $itemName, mrp: $mrp, baseRate: $baseRate, sellingRate: $sellingRate, quantity: $quantity, gstPercent: $gstPercent, discountPercent: $discountPercent, freeQty: $freeQty)';
}


}

/// @nodoc
abstract mixin class $DraftItemCopyWith<$Res>  {
  factory $DraftItemCopyWith(DraftItem value, $Res Function(DraftItem) _then) = _$DraftItemCopyWithImpl;
@useResult
$Res call({
 String productId, String itemCode, String itemName, double mrp, double baseRate, double sellingRate, int quantity, double gstPercent, double discountPercent, int freeQty
});




}
/// @nodoc
class _$DraftItemCopyWithImpl<$Res>
    implements $DraftItemCopyWith<$Res> {
  _$DraftItemCopyWithImpl(this._self, this._then);

  final DraftItem _self;
  final $Res Function(DraftItem) _then;

/// Create a copy of DraftItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? itemCode = null,Object? itemName = null,Object? mrp = null,Object? baseRate = null,Object? sellingRate = null,Object? quantity = null,Object? gstPercent = null,Object? discountPercent = null,Object? freeQty = null,}) {
  return _then(_self.copyWith(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,itemCode: null == itemCode ? _self.itemCode : itemCode // ignore: cast_nullable_to_non_nullable
as String,itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,mrp: null == mrp ? _self.mrp : mrp // ignore: cast_nullable_to_non_nullable
as double,baseRate: null == baseRate ? _self.baseRate : baseRate // ignore: cast_nullable_to_non_nullable
as double,sellingRate: null == sellingRate ? _self.sellingRate : sellingRate // ignore: cast_nullable_to_non_nullable
as double,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,gstPercent: null == gstPercent ? _self.gstPercent : gstPercent // ignore: cast_nullable_to_non_nullable
as double,discountPercent: null == discountPercent ? _self.discountPercent : discountPercent // ignore: cast_nullable_to_non_nullable
as double,freeQty: null == freeQty ? _self.freeQty : freeQty // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DraftItem].
extension DraftItemPatterns on DraftItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DraftItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DraftItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DraftItem value)  $default,){
final _that = this;
switch (_that) {
case _DraftItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DraftItem value)?  $default,){
final _that = this;
switch (_that) {
case _DraftItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String productId,  String itemCode,  String itemName,  double mrp,  double baseRate,  double sellingRate,  int quantity,  double gstPercent,  double discountPercent,  int freeQty)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DraftItem() when $default != null:
return $default(_that.productId,_that.itemCode,_that.itemName,_that.mrp,_that.baseRate,_that.sellingRate,_that.quantity,_that.gstPercent,_that.discountPercent,_that.freeQty);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String productId,  String itemCode,  String itemName,  double mrp,  double baseRate,  double sellingRate,  int quantity,  double gstPercent,  double discountPercent,  int freeQty)  $default,) {final _that = this;
switch (_that) {
case _DraftItem():
return $default(_that.productId,_that.itemCode,_that.itemName,_that.mrp,_that.baseRate,_that.sellingRate,_that.quantity,_that.gstPercent,_that.discountPercent,_that.freeQty);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String productId,  String itemCode,  String itemName,  double mrp,  double baseRate,  double sellingRate,  int quantity,  double gstPercent,  double discountPercent,  int freeQty)?  $default,) {final _that = this;
switch (_that) {
case _DraftItem() when $default != null:
return $default(_that.productId,_that.itemCode,_that.itemName,_that.mrp,_that.baseRate,_that.sellingRate,_that.quantity,_that.gstPercent,_that.discountPercent,_that.freeQty);case _:
  return null;

}
}

}

/// @nodoc


class _DraftItem extends DraftItem {
  const _DraftItem({required this.productId, required this.itemCode, required this.itemName, required this.mrp, required this.baseRate, required this.sellingRate, required this.quantity, required this.gstPercent, this.discountPercent = 0, this.freeQty = 0}): super._();
  

@override final  String productId;
@override final  String itemCode;
@override final  String itemName;
@override final  double mrp;
@override final  double baseRate;
@override final  double sellingRate;
@override final  int quantity;
@override final  double gstPercent;
@override@JsonKey() final  double discountPercent;
@override@JsonKey() final  int freeQty;

/// Create a copy of DraftItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DraftItemCopyWith<_DraftItem> get copyWith => __$DraftItemCopyWithImpl<_DraftItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DraftItem&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.itemCode, itemCode) || other.itemCode == itemCode)&&(identical(other.itemName, itemName) || other.itemName == itemName)&&(identical(other.mrp, mrp) || other.mrp == mrp)&&(identical(other.baseRate, baseRate) || other.baseRate == baseRate)&&(identical(other.sellingRate, sellingRate) || other.sellingRate == sellingRate)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.gstPercent, gstPercent) || other.gstPercent == gstPercent)&&(identical(other.discountPercent, discountPercent) || other.discountPercent == discountPercent)&&(identical(other.freeQty, freeQty) || other.freeQty == freeQty));
}


@override
int get hashCode => Object.hash(runtimeType,productId,itemCode,itemName,mrp,baseRate,sellingRate,quantity,gstPercent,discountPercent,freeQty);

@override
String toString() {
  return 'DraftItem(productId: $productId, itemCode: $itemCode, itemName: $itemName, mrp: $mrp, baseRate: $baseRate, sellingRate: $sellingRate, quantity: $quantity, gstPercent: $gstPercent, discountPercent: $discountPercent, freeQty: $freeQty)';
}


}

/// @nodoc
abstract mixin class _$DraftItemCopyWith<$Res> implements $DraftItemCopyWith<$Res> {
  factory _$DraftItemCopyWith(_DraftItem value, $Res Function(_DraftItem) _then) = __$DraftItemCopyWithImpl;
@override @useResult
$Res call({
 String productId, String itemCode, String itemName, double mrp, double baseRate, double sellingRate, int quantity, double gstPercent, double discountPercent, int freeQty
});




}
/// @nodoc
class __$DraftItemCopyWithImpl<$Res>
    implements _$DraftItemCopyWith<$Res> {
  __$DraftItemCopyWithImpl(this._self, this._then);

  final _DraftItem _self;
  final $Res Function(_DraftItem) _then;

/// Create a copy of DraftItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? itemCode = null,Object? itemName = null,Object? mrp = null,Object? baseRate = null,Object? sellingRate = null,Object? quantity = null,Object? gstPercent = null,Object? discountPercent = null,Object? freeQty = null,}) {
  return _then(_DraftItem(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,itemCode: null == itemCode ? _self.itemCode : itemCode // ignore: cast_nullable_to_non_nullable
as String,itemName: null == itemName ? _self.itemName : itemName // ignore: cast_nullable_to_non_nullable
as String,mrp: null == mrp ? _self.mrp : mrp // ignore: cast_nullable_to_non_nullable
as double,baseRate: null == baseRate ? _self.baseRate : baseRate // ignore: cast_nullable_to_non_nullable
as double,sellingRate: null == sellingRate ? _self.sellingRate : sellingRate // ignore: cast_nullable_to_non_nullable
as double,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,gstPercent: null == gstPercent ? _self.gstPercent : gstPercent // ignore: cast_nullable_to_non_nullable
as double,discountPercent: null == discountPercent ? _self.discountPercent : discountPercent // ignore: cast_nullable_to_non_nullable
as double,freeQty: null == freeQty ? _self.freeQty : freeQty // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
