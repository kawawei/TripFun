// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Trip _$TripFromJson(Map<String, dynamic> json) {
  return _Trip.fromJson(json);
}

/// @nodoc
mixin _$Trip {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  int get memberCount => throw _privateConstructorUsedError;
  String? get iconName => throw _privateConstructorUsedError;
  int? get colorValue => throw _privateConstructorUsedError;
  List<TripActivity> get activities => throw _privateConstructorUsedError;

  /// Serializes this Trip to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TripCopyWith<Trip> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripCopyWith<$Res> {
  factory $TripCopyWith(Trip value, $Res Function(Trip) then) =
      _$TripCopyWithImpl<$Res, Trip>;
  @useResult
  $Res call({
    String id,
    String title,
    String location,
    DateTime startDate,
    DateTime endDate,
    int memberCount,
    String? iconName,
    int? colorValue,
    List<TripActivity> activities,
  });
}

/// @nodoc
class _$TripCopyWithImpl<$Res, $Val extends Trip>
    implements $TripCopyWith<$Res> {
  _$TripCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? location = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? memberCount = null,
    Object? iconName = freezed,
    Object? colorValue = freezed,
    Object? activities = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            location: null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String,
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endDate: null == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            memberCount: null == memberCount
                ? _value.memberCount
                : memberCount // ignore: cast_nullable_to_non_nullable
                      as int,
            iconName: freezed == iconName
                ? _value.iconName
                : iconName // ignore: cast_nullable_to_non_nullable
                      as String?,
            colorValue: freezed == colorValue
                ? _value.colorValue
                : colorValue // ignore: cast_nullable_to_non_nullable
                      as int?,
            activities: null == activities
                ? _value.activities
                : activities // ignore: cast_nullable_to_non_nullable
                      as List<TripActivity>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TripImplCopyWith<$Res> implements $TripCopyWith<$Res> {
  factory _$$TripImplCopyWith(
    _$TripImpl value,
    $Res Function(_$TripImpl) then,
  ) = __$$TripImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String location,
    DateTime startDate,
    DateTime endDate,
    int memberCount,
    String? iconName,
    int? colorValue,
    List<TripActivity> activities,
  });
}

/// @nodoc
class __$$TripImplCopyWithImpl<$Res>
    extends _$TripCopyWithImpl<$Res, _$TripImpl>
    implements _$$TripImplCopyWith<$Res> {
  __$$TripImplCopyWithImpl(_$TripImpl _value, $Res Function(_$TripImpl) _then)
    : super(_value, _then);

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? location = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? memberCount = null,
    Object? iconName = freezed,
    Object? colorValue = freezed,
    Object? activities = null,
  }) {
    return _then(
      _$TripImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        location: null == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String,
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endDate: null == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        memberCount: null == memberCount
            ? _value.memberCount
            : memberCount // ignore: cast_nullable_to_non_nullable
                  as int,
        iconName: freezed == iconName
            ? _value.iconName
            : iconName // ignore: cast_nullable_to_non_nullable
                  as String?,
        colorValue: freezed == colorValue
            ? _value.colorValue
            : colorValue // ignore: cast_nullable_to_non_nullable
                  as int?,
        activities: null == activities
            ? _value._activities
            : activities // ignore: cast_nullable_to_non_nullable
                  as List<TripActivity>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TripImpl implements _Trip {
  const _$TripImpl({
    required this.id,
    required this.title,
    required this.location,
    required this.startDate,
    required this.endDate,
    this.memberCount = 1,
    this.iconName,
    this.colorValue,
    final List<TripActivity> activities = const [],
  }) : _activities = activities;

  factory _$TripImpl.fromJson(Map<String, dynamic> json) =>
      _$$TripImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String location;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  @JsonKey()
  final int memberCount;
  @override
  final String? iconName;
  @override
  final int? colorValue;
  final List<TripActivity> _activities;
  @override
  @JsonKey()
  List<TripActivity> get activities {
    if (_activities is EqualUnmodifiableListView) return _activities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activities);
  }

  @override
  String toString() {
    return 'Trip(id: $id, title: $title, location: $location, startDate: $startDate, endDate: $endDate, memberCount: $memberCount, iconName: $iconName, colorValue: $colorValue, activities: $activities)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.memberCount, memberCount) ||
                other.memberCount == memberCount) &&
            (identical(other.iconName, iconName) ||
                other.iconName == iconName) &&
            (identical(other.colorValue, colorValue) ||
                other.colorValue == colorValue) &&
            const DeepCollectionEquality().equals(
              other._activities,
              _activities,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    location,
    startDate,
    endDate,
    memberCount,
    iconName,
    colorValue,
    const DeepCollectionEquality().hash(_activities),
  );

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TripImplCopyWith<_$TripImpl> get copyWith =>
      __$$TripImplCopyWithImpl<_$TripImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TripImplToJson(this);
  }
}

abstract class _Trip implements Trip {
  const factory _Trip({
    required final String id,
    required final String title,
    required final String location,
    required final DateTime startDate,
    required final DateTime endDate,
    final int memberCount,
    final String? iconName,
    final int? colorValue,
    final List<TripActivity> activities,
  }) = _$TripImpl;

  factory _Trip.fromJson(Map<String, dynamic> json) = _$TripImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get location;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  int get memberCount;
  @override
  String? get iconName;
  @override
  int? get colorValue;
  @override
  List<TripActivity> get activities;

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TripImplCopyWith<_$TripImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TripActivity _$TripActivityFromJson(Map<String, dynamic> json) {
  return _TripActivity.fromJson(json);
}

/// @nodoc
mixin _$TripActivity {
  String get id => throw _privateConstructorUsedError;
  String get time => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get subtitle => throw _privateConstructorUsedError;
  String get iconName => throw _privateConstructorUsedError;
  Map<String, String>? get personalInfo => throw _privateConstructorUsedError;
  bool get isFirst => throw _privateConstructorUsedError;
  bool get isLast => throw _privateConstructorUsedError;

  /// Serializes this TripActivity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TripActivity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TripActivityCopyWith<TripActivity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripActivityCopyWith<$Res> {
  factory $TripActivityCopyWith(
    TripActivity value,
    $Res Function(TripActivity) then,
  ) = _$TripActivityCopyWithImpl<$Res, TripActivity>;
  @useResult
  $Res call({
    String id,
    String time,
    String title,
    String subtitle,
    String iconName,
    Map<String, String>? personalInfo,
    bool isFirst,
    bool isLast,
  });
}

/// @nodoc
class _$TripActivityCopyWithImpl<$Res, $Val extends TripActivity>
    implements $TripActivityCopyWith<$Res> {
  _$TripActivityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TripActivity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? time = null,
    Object? title = null,
    Object? subtitle = null,
    Object? iconName = null,
    Object? personalInfo = freezed,
    Object? isFirst = null,
    Object? isLast = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            time: null == time
                ? _value.time
                : time // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            subtitle: null == subtitle
                ? _value.subtitle
                : subtitle // ignore: cast_nullable_to_non_nullable
                      as String,
            iconName: null == iconName
                ? _value.iconName
                : iconName // ignore: cast_nullable_to_non_nullable
                      as String,
            personalInfo: freezed == personalInfo
                ? _value.personalInfo
                : personalInfo // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>?,
            isFirst: null == isFirst
                ? _value.isFirst
                : isFirst // ignore: cast_nullable_to_non_nullable
                      as bool,
            isLast: null == isLast
                ? _value.isLast
                : isLast // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TripActivityImplCopyWith<$Res>
    implements $TripActivityCopyWith<$Res> {
  factory _$$TripActivityImplCopyWith(
    _$TripActivityImpl value,
    $Res Function(_$TripActivityImpl) then,
  ) = __$$TripActivityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String time,
    String title,
    String subtitle,
    String iconName,
    Map<String, String>? personalInfo,
    bool isFirst,
    bool isLast,
  });
}

/// @nodoc
class __$$TripActivityImplCopyWithImpl<$Res>
    extends _$TripActivityCopyWithImpl<$Res, _$TripActivityImpl>
    implements _$$TripActivityImplCopyWith<$Res> {
  __$$TripActivityImplCopyWithImpl(
    _$TripActivityImpl _value,
    $Res Function(_$TripActivityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TripActivity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? time = null,
    Object? title = null,
    Object? subtitle = null,
    Object? iconName = null,
    Object? personalInfo = freezed,
    Object? isFirst = null,
    Object? isLast = null,
  }) {
    return _then(
      _$TripActivityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        time: null == time
            ? _value.time
            : time // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        subtitle: null == subtitle
            ? _value.subtitle
            : subtitle // ignore: cast_nullable_to_non_nullable
                  as String,
        iconName: null == iconName
            ? _value.iconName
            : iconName // ignore: cast_nullable_to_non_nullable
                  as String,
        personalInfo: freezed == personalInfo
            ? _value._personalInfo
            : personalInfo // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>?,
        isFirst: null == isFirst
            ? _value.isFirst
            : isFirst // ignore: cast_nullable_to_non_nullable
                  as bool,
        isLast: null == isLast
            ? _value.isLast
            : isLast // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TripActivityImpl implements _TripActivity {
  const _$TripActivityImpl({
    required this.id,
    required this.time,
    required this.title,
    required this.subtitle,
    required this.iconName,
    final Map<String, String>? personalInfo,
    this.isFirst = false,
    this.isLast = false,
  }) : _personalInfo = personalInfo;

  factory _$TripActivityImpl.fromJson(Map<String, dynamic> json) =>
      _$$TripActivityImplFromJson(json);

  @override
  final String id;
  @override
  final String time;
  @override
  final String title;
  @override
  final String subtitle;
  @override
  final String iconName;
  final Map<String, String>? _personalInfo;
  @override
  Map<String, String>? get personalInfo {
    final value = _personalInfo;
    if (value == null) return null;
    if (_personalInfo is EqualUnmodifiableMapView) return _personalInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  final bool isFirst;
  @override
  @JsonKey()
  final bool isLast;

  @override
  String toString() {
    return 'TripActivity(id: $id, time: $time, title: $title, subtitle: $subtitle, iconName: $iconName, personalInfo: $personalInfo, isFirst: $isFirst, isLast: $isLast)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripActivityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.subtitle, subtitle) ||
                other.subtitle == subtitle) &&
            (identical(other.iconName, iconName) ||
                other.iconName == iconName) &&
            const DeepCollectionEquality().equals(
              other._personalInfo,
              _personalInfo,
            ) &&
            (identical(other.isFirst, isFirst) || other.isFirst == isFirst) &&
            (identical(other.isLast, isLast) || other.isLast == isLast));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    time,
    title,
    subtitle,
    iconName,
    const DeepCollectionEquality().hash(_personalInfo),
    isFirst,
    isLast,
  );

  /// Create a copy of TripActivity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TripActivityImplCopyWith<_$TripActivityImpl> get copyWith =>
      __$$TripActivityImplCopyWithImpl<_$TripActivityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TripActivityImplToJson(this);
  }
}

abstract class _TripActivity implements TripActivity {
  const factory _TripActivity({
    required final String id,
    required final String time,
    required final String title,
    required final String subtitle,
    required final String iconName,
    final Map<String, String>? personalInfo,
    final bool isFirst,
    final bool isLast,
  }) = _$TripActivityImpl;

  factory _TripActivity.fromJson(Map<String, dynamic> json) =
      _$TripActivityImpl.fromJson;

  @override
  String get id;
  @override
  String get time;
  @override
  String get title;
  @override
  String get subtitle;
  @override
  String get iconName;
  @override
  Map<String, String>? get personalInfo;
  @override
  bool get isFirst;
  @override
  bool get isLast;

  /// Create a copy of TripActivity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TripActivityImplCopyWith<_$TripActivityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
