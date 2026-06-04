// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'distributor.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Distributor {

 String get id; String get name; String get phone; String get email;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of Distributor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DistributorCopyWith<Distributor> get copyWith => _$DistributorCopyWithImpl<Distributor>(this as Distributor, _$identity);

  /// Serializes this Distributor to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Distributor&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,phone,email,createdAt);

@override
String toString() {
  return 'Distributor(id: $id, name: $name, phone: $phone, email: $email, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $DistributorCopyWith<$Res>  {
  factory $DistributorCopyWith(Distributor value, $Res Function(Distributor) _then) = _$DistributorCopyWithImpl;
@useResult
$Res call({
 String id, String name, String phone, String email,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$DistributorCopyWithImpl<$Res>
    implements $DistributorCopyWith<$Res> {
  _$DistributorCopyWithImpl(this._self, this._then);

  final Distributor _self;
  final $Res Function(Distributor) _then;

/// Create a copy of Distributor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? phone = null,Object? email = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Distributor].
extension DistributorPatterns on Distributor {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Distributor value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Distributor() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Distributor value)  $default,){
final _that = this;
switch (_that) {
case _Distributor():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Distributor value)?  $default,){
final _that = this;
switch (_that) {
case _Distributor() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String phone,  String email, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Distributor() when $default != null:
return $default(_that.id,_that.name,_that.phone,_that.email,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String phone,  String email, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _Distributor():
return $default(_that.id,_that.name,_that.phone,_that.email,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String phone,  String email, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Distributor() when $default != null:
return $default(_that.id,_that.name,_that.phone,_that.email,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Distributor implements Distributor {
  const _Distributor({required this.id, required this.name, required this.phone, required this.email, @JsonKey(name: 'created_at') required this.createdAt});
  factory _Distributor.fromJson(Map<String, dynamic> json) => _$DistributorFromJson(json);

@override final  String id;
@override final  String name;
@override final  String phone;
@override final  String email;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of Distributor
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DistributorCopyWith<_Distributor> get copyWith => __$DistributorCopyWithImpl<_Distributor>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DistributorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Distributor&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,phone,email,createdAt);

@override
String toString() {
  return 'Distributor(id: $id, name: $name, phone: $phone, email: $email, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$DistributorCopyWith<$Res> implements $DistributorCopyWith<$Res> {
  factory _$DistributorCopyWith(_Distributor value, $Res Function(_Distributor) _then) = __$DistributorCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String phone, String email,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$DistributorCopyWithImpl<$Res>
    implements _$DistributorCopyWith<$Res> {
  __$DistributorCopyWithImpl(this._self, this._then);

  final _Distributor _self;
  final $Res Function(_Distributor) _then;

/// Create a copy of Distributor
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? phone = null,Object? email = null,Object? createdAt = null,}) {
  return _then(_Distributor(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
