// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_with_items.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrderWithItems {

 Order get order; List<OrderItem> get items;
/// Create a copy of OrderWithItems
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderWithItemsCopyWith<OrderWithItems> get copyWith => _$OrderWithItemsCopyWithImpl<OrderWithItems>(this as OrderWithItems, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderWithItems&&(identical(other.order, order) || other.order == order)&&const DeepCollectionEquality().equals(other.items, items));
}


@override
int get hashCode => Object.hash(runtimeType,order,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'OrderWithItems(order: $order, items: $items)';
}


}

/// @nodoc
abstract mixin class $OrderWithItemsCopyWith<$Res>  {
  factory $OrderWithItemsCopyWith(OrderWithItems value, $Res Function(OrderWithItems) _then) = _$OrderWithItemsCopyWithImpl;
@useResult
$Res call({
 Order order, List<OrderItem> items
});


$OrderCopyWith<$Res> get order;

}
/// @nodoc
class _$OrderWithItemsCopyWithImpl<$Res>
    implements $OrderWithItemsCopyWith<$Res> {
  _$OrderWithItemsCopyWithImpl(this._self, this._then);

  final OrderWithItems _self;
  final $Res Function(OrderWithItems) _then;

/// Create a copy of OrderWithItems
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? order = null,Object? items = null,}) {
  return _then(_self.copyWith(
order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as Order,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItem>,
  ));
}
/// Create a copy of OrderWithItems
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderCopyWith<$Res> get order {
  
  return $OrderCopyWith<$Res>(_self.order, (value) {
    return _then(_self.copyWith(order: value));
  });
}
}


/// Adds pattern-matching-related methods to [OrderWithItems].
extension OrderWithItemsPatterns on OrderWithItems {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderWithItems value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderWithItems() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderWithItems value)  $default,){
final _that = this;
switch (_that) {
case _OrderWithItems():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderWithItems value)?  $default,){
final _that = this;
switch (_that) {
case _OrderWithItems() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Order order,  List<OrderItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderWithItems() when $default != null:
return $default(_that.order,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Order order,  List<OrderItem> items)  $default,) {final _that = this;
switch (_that) {
case _OrderWithItems():
return $default(_that.order,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Order order,  List<OrderItem> items)?  $default,) {final _that = this;
switch (_that) {
case _OrderWithItems() when $default != null:
return $default(_that.order,_that.items);case _:
  return null;

}
}

}

/// @nodoc


class _OrderWithItems implements OrderWithItems {
  const _OrderWithItems({required this.order, required final  List<OrderItem> items}): _items = items;
  

@override final  Order order;
 final  List<OrderItem> _items;
@override List<OrderItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of OrderWithItems
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderWithItemsCopyWith<_OrderWithItems> get copyWith => __$OrderWithItemsCopyWithImpl<_OrderWithItems>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderWithItems&&(identical(other.order, order) || other.order == order)&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,order,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'OrderWithItems(order: $order, items: $items)';
}


}

/// @nodoc
abstract mixin class _$OrderWithItemsCopyWith<$Res> implements $OrderWithItemsCopyWith<$Res> {
  factory _$OrderWithItemsCopyWith(_OrderWithItems value, $Res Function(_OrderWithItems) _then) = __$OrderWithItemsCopyWithImpl;
@override @useResult
$Res call({
 Order order, List<OrderItem> items
});


@override $OrderCopyWith<$Res> get order;

}
/// @nodoc
class __$OrderWithItemsCopyWithImpl<$Res>
    implements _$OrderWithItemsCopyWith<$Res> {
  __$OrderWithItemsCopyWithImpl(this._self, this._then);

  final _OrderWithItems _self;
  final $Res Function(_OrderWithItems) _then;

/// Create a copy of OrderWithItems
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? order = null,Object? items = null,}) {
  return _then(_OrderWithItems(
order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as Order,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItem>,
  ));
}

/// Create a copy of OrderWithItems
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderCopyWith<$Res> get order {
  
  return $OrderCopyWith<$Res>(_self.order, (value) {
    return _then(_self.copyWith(order: value));
  });
}
}

// dart format on
