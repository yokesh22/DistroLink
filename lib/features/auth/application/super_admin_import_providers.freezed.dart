// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'super_admin_import_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ImportResult implements DiagnosticableTreeMixin {

 int get added; int get skipped;
/// Create a copy of ImportResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImportResultCopyWith<ImportResult> get copyWith => _$ImportResultCopyWithImpl<ImportResult>(this as ImportResult, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ImportResult'))
    ..add(DiagnosticsProperty('added', added))..add(DiagnosticsProperty('skipped', skipped));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImportResult&&(identical(other.added, added) || other.added == added)&&(identical(other.skipped, skipped) || other.skipped == skipped));
}


@override
int get hashCode => Object.hash(runtimeType,added,skipped);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ImportResult(added: $added, skipped: $skipped)';
}


}

/// @nodoc
abstract mixin class $ImportResultCopyWith<$Res>  {
  factory $ImportResultCopyWith(ImportResult value, $Res Function(ImportResult) _then) = _$ImportResultCopyWithImpl;
@useResult
$Res call({
 int added, int skipped
});




}
/// @nodoc
class _$ImportResultCopyWithImpl<$Res>
    implements $ImportResultCopyWith<$Res> {
  _$ImportResultCopyWithImpl(this._self, this._then);

  final ImportResult _self;
  final $Res Function(ImportResult) _then;

/// Create a copy of ImportResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? added = null,Object? skipped = null,}) {
  return _then(_self.copyWith(
added: null == added ? _self.added : added // ignore: cast_nullable_to_non_nullable
as int,skipped: null == skipped ? _self.skipped : skipped // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ImportResult].
extension ImportResultPatterns on ImportResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImportResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImportResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImportResult value)  $default,){
final _that = this;
switch (_that) {
case _ImportResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImportResult value)?  $default,){
final _that = this;
switch (_that) {
case _ImportResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int added,  int skipped)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImportResult() when $default != null:
return $default(_that.added,_that.skipped);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int added,  int skipped)  $default,) {final _that = this;
switch (_that) {
case _ImportResult():
return $default(_that.added,_that.skipped);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int added,  int skipped)?  $default,) {final _that = this;
switch (_that) {
case _ImportResult() when $default != null:
return $default(_that.added,_that.skipped);case _:
  return null;

}
}

}

/// @nodoc


class _ImportResult with DiagnosticableTreeMixin implements ImportResult {
  const _ImportResult({required this.added, required this.skipped});
  

@override final  int added;
@override final  int skipped;

/// Create a copy of ImportResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImportResultCopyWith<_ImportResult> get copyWith => __$ImportResultCopyWithImpl<_ImportResult>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ImportResult'))
    ..add(DiagnosticsProperty('added', added))..add(DiagnosticsProperty('skipped', skipped));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImportResult&&(identical(other.added, added) || other.added == added)&&(identical(other.skipped, skipped) || other.skipped == skipped));
}


@override
int get hashCode => Object.hash(runtimeType,added,skipped);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ImportResult(added: $added, skipped: $skipped)';
}


}

/// @nodoc
abstract mixin class _$ImportResultCopyWith<$Res> implements $ImportResultCopyWith<$Res> {
  factory _$ImportResultCopyWith(_ImportResult value, $Res Function(_ImportResult) _then) = __$ImportResultCopyWithImpl;
@override @useResult
$Res call({
 int added, int skipped
});




}
/// @nodoc
class __$ImportResultCopyWithImpl<$Res>
    implements _$ImportResultCopyWith<$Res> {
  __$ImportResultCopyWithImpl(this._self, this._then);

  final _ImportResult _self;
  final $Res Function(_ImportResult) _then;

/// Create a copy of ImportResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? added = null,Object? skipped = null,}) {
  return _then(_ImportResult(
added: null == added ? _self.added : added // ignore: cast_nullable_to_non_nullable
as int,skipped: null == skipped ? _self.skipped : skipped // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$BulkImportState implements DiagnosticableTreeMixin {

 ImportType get type; Distributor? get distributor; String? get fileName; AreaImportParse? get areaParse; ShopSheetParse? get shopParse; ItemSheetParse? get itemParse;// Shared insert plan for shops/items (only one type active at a time).
 ImportPlan? get plan; ImportPhase get phase; ImportResult? get result; String? get errorMessage;
/// Create a copy of BulkImportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BulkImportStateCopyWith<BulkImportState> get copyWith => _$BulkImportStateCopyWithImpl<BulkImportState>(this as BulkImportState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'BulkImportState'))
    ..add(DiagnosticsProperty('type', type))..add(DiagnosticsProperty('distributor', distributor))..add(DiagnosticsProperty('fileName', fileName))..add(DiagnosticsProperty('areaParse', areaParse))..add(DiagnosticsProperty('shopParse', shopParse))..add(DiagnosticsProperty('itemParse', itemParse))..add(DiagnosticsProperty('plan', plan))..add(DiagnosticsProperty('phase', phase))..add(DiagnosticsProperty('result', result))..add(DiagnosticsProperty('errorMessage', errorMessage));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BulkImportState&&(identical(other.type, type) || other.type == type)&&(identical(other.distributor, distributor) || other.distributor == distributor)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.areaParse, areaParse) || other.areaParse == areaParse)&&(identical(other.shopParse, shopParse) || other.shopParse == shopParse)&&(identical(other.itemParse, itemParse) || other.itemParse == itemParse)&&(identical(other.plan, plan) || other.plan == plan)&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.result, result) || other.result == result)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,type,distributor,fileName,areaParse,shopParse,itemParse,plan,phase,result,errorMessage);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'BulkImportState(type: $type, distributor: $distributor, fileName: $fileName, areaParse: $areaParse, shopParse: $shopParse, itemParse: $itemParse, plan: $plan, phase: $phase, result: $result, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $BulkImportStateCopyWith<$Res>  {
  factory $BulkImportStateCopyWith(BulkImportState value, $Res Function(BulkImportState) _then) = _$BulkImportStateCopyWithImpl;
@useResult
$Res call({
 ImportType type, Distributor? distributor, String? fileName, AreaImportParse? areaParse, ShopSheetParse? shopParse, ItemSheetParse? itemParse, ImportPlan? plan, ImportPhase phase, ImportResult? result, String? errorMessage
});


$DistributorCopyWith<$Res>? get distributor;$ImportResultCopyWith<$Res>? get result;

}
/// @nodoc
class _$BulkImportStateCopyWithImpl<$Res>
    implements $BulkImportStateCopyWith<$Res> {
  _$BulkImportStateCopyWithImpl(this._self, this._then);

  final BulkImportState _self;
  final $Res Function(BulkImportState) _then;

/// Create a copy of BulkImportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? distributor = freezed,Object? fileName = freezed,Object? areaParse = freezed,Object? shopParse = freezed,Object? itemParse = freezed,Object? plan = freezed,Object? phase = null,Object? result = freezed,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ImportType,distributor: freezed == distributor ? _self.distributor : distributor // ignore: cast_nullable_to_non_nullable
as Distributor?,fileName: freezed == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String?,areaParse: freezed == areaParse ? _self.areaParse : areaParse // ignore: cast_nullable_to_non_nullable
as AreaImportParse?,shopParse: freezed == shopParse ? _self.shopParse : shopParse // ignore: cast_nullable_to_non_nullable
as ShopSheetParse?,itemParse: freezed == itemParse ? _self.itemParse : itemParse // ignore: cast_nullable_to_non_nullable
as ItemSheetParse?,plan: freezed == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as ImportPlan?,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as ImportPhase,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as ImportResult?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of BulkImportState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DistributorCopyWith<$Res>? get distributor {
    if (_self.distributor == null) {
    return null;
  }

  return $DistributorCopyWith<$Res>(_self.distributor!, (value) {
    return _then(_self.copyWith(distributor: value));
  });
}/// Create a copy of BulkImportState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ImportResultCopyWith<$Res>? get result {
    if (_self.result == null) {
    return null;
  }

  return $ImportResultCopyWith<$Res>(_self.result!, (value) {
    return _then(_self.copyWith(result: value));
  });
}
}


/// Adds pattern-matching-related methods to [BulkImportState].
extension BulkImportStatePatterns on BulkImportState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BulkImportState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BulkImportState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BulkImportState value)  $default,){
final _that = this;
switch (_that) {
case _BulkImportState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BulkImportState value)?  $default,){
final _that = this;
switch (_that) {
case _BulkImportState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ImportType type,  Distributor? distributor,  String? fileName,  AreaImportParse? areaParse,  ShopSheetParse? shopParse,  ItemSheetParse? itemParse,  ImportPlan? plan,  ImportPhase phase,  ImportResult? result,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BulkImportState() when $default != null:
return $default(_that.type,_that.distributor,_that.fileName,_that.areaParse,_that.shopParse,_that.itemParse,_that.plan,_that.phase,_that.result,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ImportType type,  Distributor? distributor,  String? fileName,  AreaImportParse? areaParse,  ShopSheetParse? shopParse,  ItemSheetParse? itemParse,  ImportPlan? plan,  ImportPhase phase,  ImportResult? result,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _BulkImportState():
return $default(_that.type,_that.distributor,_that.fileName,_that.areaParse,_that.shopParse,_that.itemParse,_that.plan,_that.phase,_that.result,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ImportType type,  Distributor? distributor,  String? fileName,  AreaImportParse? areaParse,  ShopSheetParse? shopParse,  ItemSheetParse? itemParse,  ImportPlan? plan,  ImportPhase phase,  ImportResult? result,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _BulkImportState() when $default != null:
return $default(_that.type,_that.distributor,_that.fileName,_that.areaParse,_that.shopParse,_that.itemParse,_that.plan,_that.phase,_that.result,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _BulkImportState with DiagnosticableTreeMixin implements BulkImportState {
  const _BulkImportState({this.type = ImportType.areas, this.distributor, this.fileName, this.areaParse, this.shopParse, this.itemParse, this.plan, this.phase = ImportPhase.idle, this.result, this.errorMessage});
  

@override@JsonKey() final  ImportType type;
@override final  Distributor? distributor;
@override final  String? fileName;
@override final  AreaImportParse? areaParse;
@override final  ShopSheetParse? shopParse;
@override final  ItemSheetParse? itemParse;
// Shared insert plan for shops/items (only one type active at a time).
@override final  ImportPlan? plan;
@override@JsonKey() final  ImportPhase phase;
@override final  ImportResult? result;
@override final  String? errorMessage;

/// Create a copy of BulkImportState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BulkImportStateCopyWith<_BulkImportState> get copyWith => __$BulkImportStateCopyWithImpl<_BulkImportState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'BulkImportState'))
    ..add(DiagnosticsProperty('type', type))..add(DiagnosticsProperty('distributor', distributor))..add(DiagnosticsProperty('fileName', fileName))..add(DiagnosticsProperty('areaParse', areaParse))..add(DiagnosticsProperty('shopParse', shopParse))..add(DiagnosticsProperty('itemParse', itemParse))..add(DiagnosticsProperty('plan', plan))..add(DiagnosticsProperty('phase', phase))..add(DiagnosticsProperty('result', result))..add(DiagnosticsProperty('errorMessage', errorMessage));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BulkImportState&&(identical(other.type, type) || other.type == type)&&(identical(other.distributor, distributor) || other.distributor == distributor)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.areaParse, areaParse) || other.areaParse == areaParse)&&(identical(other.shopParse, shopParse) || other.shopParse == shopParse)&&(identical(other.itemParse, itemParse) || other.itemParse == itemParse)&&(identical(other.plan, plan) || other.plan == plan)&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.result, result) || other.result == result)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,type,distributor,fileName,areaParse,shopParse,itemParse,plan,phase,result,errorMessage);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'BulkImportState(type: $type, distributor: $distributor, fileName: $fileName, areaParse: $areaParse, shopParse: $shopParse, itemParse: $itemParse, plan: $plan, phase: $phase, result: $result, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$BulkImportStateCopyWith<$Res> implements $BulkImportStateCopyWith<$Res> {
  factory _$BulkImportStateCopyWith(_BulkImportState value, $Res Function(_BulkImportState) _then) = __$BulkImportStateCopyWithImpl;
@override @useResult
$Res call({
 ImportType type, Distributor? distributor, String? fileName, AreaImportParse? areaParse, ShopSheetParse? shopParse, ItemSheetParse? itemParse, ImportPlan? plan, ImportPhase phase, ImportResult? result, String? errorMessage
});


@override $DistributorCopyWith<$Res>? get distributor;@override $ImportResultCopyWith<$Res>? get result;

}
/// @nodoc
class __$BulkImportStateCopyWithImpl<$Res>
    implements _$BulkImportStateCopyWith<$Res> {
  __$BulkImportStateCopyWithImpl(this._self, this._then);

  final _BulkImportState _self;
  final $Res Function(_BulkImportState) _then;

/// Create a copy of BulkImportState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? distributor = freezed,Object? fileName = freezed,Object? areaParse = freezed,Object? shopParse = freezed,Object? itemParse = freezed,Object? plan = freezed,Object? phase = null,Object? result = freezed,Object? errorMessage = freezed,}) {
  return _then(_BulkImportState(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ImportType,distributor: freezed == distributor ? _self.distributor : distributor // ignore: cast_nullable_to_non_nullable
as Distributor?,fileName: freezed == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String?,areaParse: freezed == areaParse ? _self.areaParse : areaParse // ignore: cast_nullable_to_non_nullable
as AreaImportParse?,shopParse: freezed == shopParse ? _self.shopParse : shopParse // ignore: cast_nullable_to_non_nullable
as ShopSheetParse?,itemParse: freezed == itemParse ? _self.itemParse : itemParse // ignore: cast_nullable_to_non_nullable
as ItemSheetParse?,plan: freezed == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as ImportPlan?,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as ImportPhase,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as ImportResult?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of BulkImportState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DistributorCopyWith<$Res>? get distributor {
    if (_self.distributor == null) {
    return null;
  }

  return $DistributorCopyWith<$Res>(_self.distributor!, (value) {
    return _then(_self.copyWith(distributor: value));
  });
}/// Create a copy of BulkImportState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ImportResultCopyWith<$Res>? get result {
    if (_self.result == null) {
    return null;
  }

  return $ImportResultCopyWith<$Res>(_self.result!, (value) {
    return _then(_self.copyWith(result: value));
  });
}
}

// dart format on
