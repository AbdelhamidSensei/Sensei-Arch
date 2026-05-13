// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String get token => throw _privateConstructorUsedError;
  int get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  List<CompanyBranches> get companiesBranches =>
      throw _privateConstructorUsedError;

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call({
    String token,
    int id,
    String email,
    String name,
    String code,
    List<CompanyBranches> companiesBranches,
  });
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? id = null,
    Object? email = null,
    Object? name = null,
    Object? code = null,
    Object? companiesBranches = null,
  }) {
    return _then(
      _value.copyWith(
            token: null == token
                ? _value.token
                : token // ignore: cast_nullable_to_non_nullable
                      as String,
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            code: null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String,
            companiesBranches: null == companiesBranches
                ? _value.companiesBranches
                : companiesBranches // ignore: cast_nullable_to_non_nullable
                      as List<CompanyBranches>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
    _$UserModelImpl value,
    $Res Function(_$UserModelImpl) then,
  ) = __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String token,
    int id,
    String email,
    String name,
    String code,
    List<CompanyBranches> companiesBranches,
  });
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
    _$UserModelImpl _value,
    $Res Function(_$UserModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? id = null,
    Object? email = null,
    Object? name = null,
    Object? code = null,
    Object? companiesBranches = null,
  }) {
    return _then(
      _$UserModelImpl(
        token: null == token
            ? _value.token
            : token // ignore: cast_nullable_to_non_nullable
                  as String,
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        code: null == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String,
        companiesBranches: null == companiesBranches
            ? _value._companiesBranches
            : companiesBranches // ignore: cast_nullable_to_non_nullable
                  as List<CompanyBranches>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl implements _UserModel {
  const _$UserModelImpl({
    required this.token,
    required this.id,
    required this.email,
    required this.name,
    required this.code,
    final List<CompanyBranches> companiesBranches = const [],
  }) : _companiesBranches = companiesBranches;

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final String token;
  @override
  final int id;
  @override
  final String email;
  @override
  final String name;
  @override
  final String code;
  final List<CompanyBranches> _companiesBranches;
  @override
  @JsonKey()
  List<CompanyBranches> get companiesBranches {
    if (_companiesBranches is EqualUnmodifiableListView)
      return _companiesBranches;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_companiesBranches);
  }

  @override
  String toString() {
    return 'UserModel(token: $token, id: $id, email: $email, name: $name, code: $code, companiesBranches: $companiesBranches)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.code, code) || other.code == code) &&
            const DeepCollectionEquality().equals(
              other._companiesBranches,
              _companiesBranches,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    token,
    id,
    email,
    name,
    code,
    const DeepCollectionEquality().hash(_companiesBranches),
  );

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(this);
  }
}

abstract class _UserModel implements UserModel {
  const factory _UserModel({
    required final String token,
    required final int id,
    required final String email,
    required final String name,
    required final String code,
    final List<CompanyBranches> companiesBranches,
  }) = _$UserModelImpl;

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  String get token;
  @override
  int get id;
  @override
  String get email;
  @override
  String get name;
  @override
  String get code;
  @override
  List<CompanyBranches> get companiesBranches;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CompanyBranches _$CompanyBranchesFromJson(Map<String, dynamic> json) {
  return _CompanyBranches.fromJson(json);
}

/// @nodoc
mixin _$CompanyBranches {
  int get companyID => throw _privateConstructorUsedError;
  List<BranchItem> get branchesList => throw _privateConstructorUsedError;

  /// Serializes this CompanyBranches to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CompanyBranches
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompanyBranchesCopyWith<CompanyBranches> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompanyBranchesCopyWith<$Res> {
  factory $CompanyBranchesCopyWith(
    CompanyBranches value,
    $Res Function(CompanyBranches) then,
  ) = _$CompanyBranchesCopyWithImpl<$Res, CompanyBranches>;
  @useResult
  $Res call({int companyID, List<BranchItem> branchesList});
}

/// @nodoc
class _$CompanyBranchesCopyWithImpl<$Res, $Val extends CompanyBranches>
    implements $CompanyBranchesCopyWith<$Res> {
  _$CompanyBranchesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CompanyBranches
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? companyID = null, Object? branchesList = null}) {
    return _then(
      _value.copyWith(
            companyID: null == companyID
                ? _value.companyID
                : companyID // ignore: cast_nullable_to_non_nullable
                      as int,
            branchesList: null == branchesList
                ? _value.branchesList
                : branchesList // ignore: cast_nullable_to_non_nullable
                      as List<BranchItem>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CompanyBranchesImplCopyWith<$Res>
    implements $CompanyBranchesCopyWith<$Res> {
  factory _$$CompanyBranchesImplCopyWith(
    _$CompanyBranchesImpl value,
    $Res Function(_$CompanyBranchesImpl) then,
  ) = __$$CompanyBranchesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int companyID, List<BranchItem> branchesList});
}

/// @nodoc
class __$$CompanyBranchesImplCopyWithImpl<$Res>
    extends _$CompanyBranchesCopyWithImpl<$Res, _$CompanyBranchesImpl>
    implements _$$CompanyBranchesImplCopyWith<$Res> {
  __$$CompanyBranchesImplCopyWithImpl(
    _$CompanyBranchesImpl _value,
    $Res Function(_$CompanyBranchesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CompanyBranches
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? companyID = null, Object? branchesList = null}) {
    return _then(
      _$CompanyBranchesImpl(
        companyID: null == companyID
            ? _value.companyID
            : companyID // ignore: cast_nullable_to_non_nullable
                  as int,
        branchesList: null == branchesList
            ? _value._branchesList
            : branchesList // ignore: cast_nullable_to_non_nullable
                  as List<BranchItem>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CompanyBranchesImpl implements _CompanyBranches {
  const _$CompanyBranchesImpl({
    required this.companyID,
    final List<BranchItem> branchesList = const [],
  }) : _branchesList = branchesList;

  factory _$CompanyBranchesImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompanyBranchesImplFromJson(json);

  @override
  final int companyID;
  final List<BranchItem> _branchesList;
  @override
  @JsonKey()
  List<BranchItem> get branchesList {
    if (_branchesList is EqualUnmodifiableListView) return _branchesList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_branchesList);
  }

  @override
  String toString() {
    return 'CompanyBranches(companyID: $companyID, branchesList: $branchesList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompanyBranchesImpl &&
            (identical(other.companyID, companyID) ||
                other.companyID == companyID) &&
            const DeepCollectionEquality().equals(
              other._branchesList,
              _branchesList,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    companyID,
    const DeepCollectionEquality().hash(_branchesList),
  );

  /// Create a copy of CompanyBranches
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompanyBranchesImplCopyWith<_$CompanyBranchesImpl> get copyWith =>
      __$$CompanyBranchesImplCopyWithImpl<_$CompanyBranchesImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CompanyBranchesImplToJson(this);
  }
}

abstract class _CompanyBranches implements CompanyBranches {
  const factory _CompanyBranches({
    required final int companyID,
    final List<BranchItem> branchesList,
  }) = _$CompanyBranchesImpl;

  factory _CompanyBranches.fromJson(Map<String, dynamic> json) =
      _$CompanyBranchesImpl.fromJson;

  @override
  int get companyID;
  @override
  List<BranchItem> get branchesList;

  /// Create a copy of CompanyBranches
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompanyBranchesImplCopyWith<_$CompanyBranchesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BranchItem _$BranchItemFromJson(Map<String, dynamic> json) {
  return _BranchItem.fromJson(json);
}

/// @nodoc
mixin _$BranchItem {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Serializes this BranchItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BranchItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BranchItemCopyWith<BranchItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BranchItemCopyWith<$Res> {
  factory $BranchItemCopyWith(
    BranchItem value,
    $Res Function(BranchItem) then,
  ) = _$BranchItemCopyWithImpl<$Res, BranchItem>;
  @useResult
  $Res call({int id, String name});
}

/// @nodoc
class _$BranchItemCopyWithImpl<$Res, $Val extends BranchItem>
    implements $BranchItemCopyWith<$Res> {
  _$BranchItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BranchItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BranchItemImplCopyWith<$Res>
    implements $BranchItemCopyWith<$Res> {
  factory _$$BranchItemImplCopyWith(
    _$BranchItemImpl value,
    $Res Function(_$BranchItemImpl) then,
  ) = __$$BranchItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name});
}

/// @nodoc
class __$$BranchItemImplCopyWithImpl<$Res>
    extends _$BranchItemCopyWithImpl<$Res, _$BranchItemImpl>
    implements _$$BranchItemImplCopyWith<$Res> {
  __$$BranchItemImplCopyWithImpl(
    _$BranchItemImpl _value,
    $Res Function(_$BranchItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BranchItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null}) {
    return _then(
      _$BranchItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BranchItemImpl implements _BranchItem {
  const _$BranchItemImpl({required this.id, required this.name});

  factory _$BranchItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$BranchItemImplFromJson(json);

  @override
  final int id;
  @override
  final String name;

  @override
  String toString() {
    return 'BranchItem(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BranchItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  /// Create a copy of BranchItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BranchItemImplCopyWith<_$BranchItemImpl> get copyWith =>
      __$$BranchItemImplCopyWithImpl<_$BranchItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BranchItemImplToJson(this);
  }
}

abstract class _BranchItem implements BranchItem {
  const factory _BranchItem({
    required final int id,
    required final String name,
  }) = _$BranchItemImpl;

  factory _BranchItem.fromJson(Map<String, dynamic> json) =
      _$BranchItemImpl.fromJson;

  @override
  int get id;
  @override
  String get name;

  /// Create a copy of BranchItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BranchItemImplCopyWith<_$BranchItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
