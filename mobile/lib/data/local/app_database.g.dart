// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TripsTable extends Trips with TableInfo<$TripsTable, Trip> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TripsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _remoteIdMeta = const VerificationMeta(
    'remoteId',
  );
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
    'remote_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _memberCountMeta = const VerificationMeta(
    'memberCount',
  );
  @override
  late final GeneratedColumn<int> memberCount = GeneratedColumn<int>(
    'member_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconNameMeta = const VerificationMeta(
    'iconName',
  );
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
    'icon_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastUpdatedMeta = const VerificationMeta(
    'lastUpdated',
  );
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
    'last_updated',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    remoteId,
    title,
    location,
    startDate,
    endDate,
    memberCount,
    status,
    iconName,
    lastUpdated,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trips';
  @override
  VerificationContext validateIntegrity(
    Insertable<Trip> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('remote_id')) {
      context.handle(
        _remoteIdMeta,
        remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_remoteIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('member_count')) {
      context.handle(
        _memberCountMeta,
        memberCount.isAcceptableOrUnknown(
          data['member_count']!,
          _memberCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_memberCountMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('icon_name')) {
      context.handle(
        _iconNameMeta,
        iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta),
      );
    }
    if (data.containsKey('last_updated')) {
      context.handle(
        _lastUpdatedMeta,
        lastUpdated.isAcceptableOrUnknown(
          data['last_updated']!,
          _lastUpdatedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Trip map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Trip(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      remoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      )!,
      memberCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}member_count'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      iconName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_name'],
      ),
      lastUpdated: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_updated'],
      ),
    );
  }

  @override
  $TripsTable createAlias(String alias) {
    return $TripsTable(attachedDatabase, alias);
  }
}

class Trip extends DataClass implements Insertable<Trip> {
  final int id;
  final String remoteId;
  final String title;
  final String? location;
  final DateTime startDate;
  final DateTime endDate;
  final int memberCount;
  final String status;
  final String? iconName;
  final DateTime? lastUpdated;
  const Trip({
    required this.id,
    required this.remoteId,
    required this.title,
    this.location,
    required this.startDate,
    required this.endDate,
    required this.memberCount,
    required this.status,
    this.iconName,
    this.lastUpdated,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['remote_id'] = Variable<String>(remoteId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['member_count'] = Variable<int>(memberCount);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || iconName != null) {
      map['icon_name'] = Variable<String>(iconName);
    }
    if (!nullToAbsent || lastUpdated != null) {
      map['last_updated'] = Variable<DateTime>(lastUpdated);
    }
    return map;
  }

  TripsCompanion toCompanion(bool nullToAbsent) {
    return TripsCompanion(
      id: Value(id),
      remoteId: Value(remoteId),
      title: Value(title),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      startDate: Value(startDate),
      endDate: Value(endDate),
      memberCount: Value(memberCount),
      status: Value(status),
      iconName: iconName == null && nullToAbsent
          ? const Value.absent()
          : Value(iconName),
      lastUpdated: lastUpdated == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUpdated),
    );
  }

  factory Trip.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Trip(
      id: serializer.fromJson<int>(json['id']),
      remoteId: serializer.fromJson<String>(json['remoteId']),
      title: serializer.fromJson<String>(json['title']),
      location: serializer.fromJson<String?>(json['location']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      memberCount: serializer.fromJson<int>(json['memberCount']),
      status: serializer.fromJson<String>(json['status']),
      iconName: serializer.fromJson<String?>(json['iconName']),
      lastUpdated: serializer.fromJson<DateTime?>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'remoteId': serializer.toJson<String>(remoteId),
      'title': serializer.toJson<String>(title),
      'location': serializer.toJson<String?>(location),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'memberCount': serializer.toJson<int>(memberCount),
      'status': serializer.toJson<String>(status),
      'iconName': serializer.toJson<String?>(iconName),
      'lastUpdated': serializer.toJson<DateTime?>(lastUpdated),
    };
  }

  Trip copyWith({
    int? id,
    String? remoteId,
    String? title,
    Value<String?> location = const Value.absent(),
    DateTime? startDate,
    DateTime? endDate,
    int? memberCount,
    String? status,
    Value<String?> iconName = const Value.absent(),
    Value<DateTime?> lastUpdated = const Value.absent(),
  }) => Trip(
    id: id ?? this.id,
    remoteId: remoteId ?? this.remoteId,
    title: title ?? this.title,
    location: location.present ? location.value : this.location,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    memberCount: memberCount ?? this.memberCount,
    status: status ?? this.status,
    iconName: iconName.present ? iconName.value : this.iconName,
    lastUpdated: lastUpdated.present ? lastUpdated.value : this.lastUpdated,
  );
  Trip copyWithCompanion(TripsCompanion data) {
    return Trip(
      id: data.id.present ? data.id.value : this.id,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      title: data.title.present ? data.title.value : this.title,
      location: data.location.present ? data.location.value : this.location,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      memberCount: data.memberCount.present
          ? data.memberCount.value
          : this.memberCount,
      status: data.status.present ? data.status.value : this.status,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      lastUpdated: data.lastUpdated.present
          ? data.lastUpdated.value
          : this.lastUpdated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Trip(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('title: $title, ')
          ..write('location: $location, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('memberCount: $memberCount, ')
          ..write('status: $status, ')
          ..write('iconName: $iconName, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    remoteId,
    title,
    location,
    startDate,
    endDate,
    memberCount,
    status,
    iconName,
    lastUpdated,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Trip &&
          other.id == this.id &&
          other.remoteId == this.remoteId &&
          other.title == this.title &&
          other.location == this.location &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.memberCount == this.memberCount &&
          other.status == this.status &&
          other.iconName == this.iconName &&
          other.lastUpdated == this.lastUpdated);
}

class TripsCompanion extends UpdateCompanion<Trip> {
  final Value<int> id;
  final Value<String> remoteId;
  final Value<String> title;
  final Value<String?> location;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<int> memberCount;
  final Value<String> status;
  final Value<String?> iconName;
  final Value<DateTime?> lastUpdated;
  const TripsCompanion({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.title = const Value.absent(),
    this.location = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.memberCount = const Value.absent(),
    this.status = const Value.absent(),
    this.iconName = const Value.absent(),
    this.lastUpdated = const Value.absent(),
  });
  TripsCompanion.insert({
    this.id = const Value.absent(),
    required String remoteId,
    required String title,
    this.location = const Value.absent(),
    required DateTime startDate,
    required DateTime endDate,
    required int memberCount,
    required String status,
    this.iconName = const Value.absent(),
    this.lastUpdated = const Value.absent(),
  }) : remoteId = Value(remoteId),
       title = Value(title),
       startDate = Value(startDate),
       endDate = Value(endDate),
       memberCount = Value(memberCount),
       status = Value(status);
  static Insertable<Trip> custom({
    Expression<int>? id,
    Expression<String>? remoteId,
    Expression<String>? title,
    Expression<String>? location,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<int>? memberCount,
    Expression<String>? status,
    Expression<String>? iconName,
    Expression<DateTime>? lastUpdated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (remoteId != null) 'remote_id': remoteId,
      if (title != null) 'title': title,
      if (location != null) 'location': location,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (memberCount != null) 'member_count': memberCount,
      if (status != null) 'status': status,
      if (iconName != null) 'icon_name': iconName,
      if (lastUpdated != null) 'last_updated': lastUpdated,
    });
  }

  TripsCompanion copyWith({
    Value<int>? id,
    Value<String>? remoteId,
    Value<String>? title,
    Value<String?>? location,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<int>? memberCount,
    Value<String>? status,
    Value<String?>? iconName,
    Value<DateTime?>? lastUpdated,
  }) {
    return TripsCompanion(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      title: title ?? this.title,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      memberCount: memberCount ?? this.memberCount,
      status: status ?? this.status,
      iconName: iconName ?? this.iconName,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (memberCount.present) {
      map['member_count'] = Variable<int>(memberCount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TripsCompanion(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('title: $title, ')
          ..write('location: $location, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('memberCount: $memberCount, ')
          ..write('status: $status, ')
          ..write('iconName: $iconName, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }
}

class $ActivitiesTable extends Activities
    with TableInfo<$ActivitiesTable, Activity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _remoteIdMeta = const VerificationMeta(
    'remoteId',
  );
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
    'remote_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<String> tripId = GeneratedColumn<String>(
    'trip_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subtitleMeta = const VerificationMeta(
    'subtitle',
  );
  @override
  late final GeneratedColumn<String> subtitle = GeneratedColumn<String>(
    'subtitle',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<String> time = GeneratedColumn<String>(
    'time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _locationNameMeta = const VerificationMeta(
    'locationName',
  );
  @override
  late final GeneratedColumn<String> locationName = GeneratedColumn<String>(
    'location_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconNameMeta = const VerificationMeta(
    'iconName',
  );
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
    'icon_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageUrlsMeta = const VerificationMeta(
    'imageUrls',
  );
  @override
  late final GeneratedColumn<String> imageUrls = GeneratedColumn<String>(
    'image_urls',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _personalInfoJsonMeta = const VerificationMeta(
    'personalInfoJson',
  );
  @override
  late final GeneratedColumn<String> personalInfoJson = GeneratedColumn<String>(
    'personal_info_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastUpdatedMeta = const VerificationMeta(
    'lastUpdated',
  );
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
    'last_updated',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    remoteId,
    tripId,
    title,
    subtitle,
    content,
    type,
    time,
    sortOrder,
    locationName,
    iconName,
    imageUrls,
    personalInfoJson,
    lastUpdated,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activities';
  @override
  VerificationContext validateIntegrity(
    Insertable<Activity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('remote_id')) {
      context.handle(
        _remoteIdMeta,
        remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_remoteIdMeta);
    }
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('subtitle')) {
      context.handle(
        _subtitleMeta,
        subtitle.isAcceptableOrUnknown(data['subtitle']!, _subtitleMeta),
      );
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('time')) {
      context.handle(
        _timeMeta,
        time.isAcceptableOrUnknown(data['time']!, _timeMeta),
      );
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('location_name')) {
      context.handle(
        _locationNameMeta,
        locationName.isAcceptableOrUnknown(
          data['location_name']!,
          _locationNameMeta,
        ),
      );
    }
    if (data.containsKey('icon_name')) {
      context.handle(
        _iconNameMeta,
        iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta),
      );
    }
    if (data.containsKey('image_urls')) {
      context.handle(
        _imageUrlsMeta,
        imageUrls.isAcceptableOrUnknown(data['image_urls']!, _imageUrlsMeta),
      );
    }
    if (data.containsKey('personal_info_json')) {
      context.handle(
        _personalInfoJsonMeta,
        personalInfoJson.isAcceptableOrUnknown(
          data['personal_info_json']!,
          _personalInfoJsonMeta,
        ),
      );
    }
    if (data.containsKey('last_updated')) {
      context.handle(
        _lastUpdatedMeta,
        lastUpdated.isAcceptableOrUnknown(
          data['last_updated']!,
          _lastUpdatedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Activity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Activity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      remoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_id'],
      )!,
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      subtitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subtitle'],
      ),
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      time: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      locationName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location_name'],
      ),
      iconName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_name'],
      ),
      imageUrls: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_urls'],
      ),
      personalInfoJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}personal_info_json'],
      ),
      lastUpdated: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_updated'],
      ),
    );
  }

  @override
  $ActivitiesTable createAlias(String alias) {
    return $ActivitiesTable(attachedDatabase, alias);
  }
}

class Activity extends DataClass implements Insertable<Activity> {
  final int id;
  final String remoteId;
  final String tripId;
  final String title;
  final String? subtitle;
  final String? content;
  final String type;
  final String time;
  final int sortOrder;
  final String? locationName;
  final String? iconName;
  final String? imageUrls;
  final String? personalInfoJson;
  final DateTime? lastUpdated;
  const Activity({
    required this.id,
    required this.remoteId,
    required this.tripId,
    required this.title,
    this.subtitle,
    this.content,
    required this.type,
    required this.time,
    required this.sortOrder,
    this.locationName,
    this.iconName,
    this.imageUrls,
    this.personalInfoJson,
    this.lastUpdated,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['remote_id'] = Variable<String>(remoteId);
    map['trip_id'] = Variable<String>(tripId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || subtitle != null) {
      map['subtitle'] = Variable<String>(subtitle);
    }
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(content);
    }
    map['type'] = Variable<String>(type);
    map['time'] = Variable<String>(time);
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || locationName != null) {
      map['location_name'] = Variable<String>(locationName);
    }
    if (!nullToAbsent || iconName != null) {
      map['icon_name'] = Variable<String>(iconName);
    }
    if (!nullToAbsent || imageUrls != null) {
      map['image_urls'] = Variable<String>(imageUrls);
    }
    if (!nullToAbsent || personalInfoJson != null) {
      map['personal_info_json'] = Variable<String>(personalInfoJson);
    }
    if (!nullToAbsent || lastUpdated != null) {
      map['last_updated'] = Variable<DateTime>(lastUpdated);
    }
    return map;
  }

  ActivitiesCompanion toCompanion(bool nullToAbsent) {
    return ActivitiesCompanion(
      id: Value(id),
      remoteId: Value(remoteId),
      tripId: Value(tripId),
      title: Value(title),
      subtitle: subtitle == null && nullToAbsent
          ? const Value.absent()
          : Value(subtitle),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      type: Value(type),
      time: Value(time),
      sortOrder: Value(sortOrder),
      locationName: locationName == null && nullToAbsent
          ? const Value.absent()
          : Value(locationName),
      iconName: iconName == null && nullToAbsent
          ? const Value.absent()
          : Value(iconName),
      imageUrls: imageUrls == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrls),
      personalInfoJson: personalInfoJson == null && nullToAbsent
          ? const Value.absent()
          : Value(personalInfoJson),
      lastUpdated: lastUpdated == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUpdated),
    );
  }

  factory Activity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Activity(
      id: serializer.fromJson<int>(json['id']),
      remoteId: serializer.fromJson<String>(json['remoteId']),
      tripId: serializer.fromJson<String>(json['tripId']),
      title: serializer.fromJson<String>(json['title']),
      subtitle: serializer.fromJson<String?>(json['subtitle']),
      content: serializer.fromJson<String?>(json['content']),
      type: serializer.fromJson<String>(json['type']),
      time: serializer.fromJson<String>(json['time']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      locationName: serializer.fromJson<String?>(json['locationName']),
      iconName: serializer.fromJson<String?>(json['iconName']),
      imageUrls: serializer.fromJson<String?>(json['imageUrls']),
      personalInfoJson: serializer.fromJson<String?>(json['personalInfoJson']),
      lastUpdated: serializer.fromJson<DateTime?>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'remoteId': serializer.toJson<String>(remoteId),
      'tripId': serializer.toJson<String>(tripId),
      'title': serializer.toJson<String>(title),
      'subtitle': serializer.toJson<String?>(subtitle),
      'content': serializer.toJson<String?>(content),
      'type': serializer.toJson<String>(type),
      'time': serializer.toJson<String>(time),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'locationName': serializer.toJson<String?>(locationName),
      'iconName': serializer.toJson<String?>(iconName),
      'imageUrls': serializer.toJson<String?>(imageUrls),
      'personalInfoJson': serializer.toJson<String?>(personalInfoJson),
      'lastUpdated': serializer.toJson<DateTime?>(lastUpdated),
    };
  }

  Activity copyWith({
    int? id,
    String? remoteId,
    String? tripId,
    String? title,
    Value<String?> subtitle = const Value.absent(),
    Value<String?> content = const Value.absent(),
    String? type,
    String? time,
    int? sortOrder,
    Value<String?> locationName = const Value.absent(),
    Value<String?> iconName = const Value.absent(),
    Value<String?> imageUrls = const Value.absent(),
    Value<String?> personalInfoJson = const Value.absent(),
    Value<DateTime?> lastUpdated = const Value.absent(),
  }) => Activity(
    id: id ?? this.id,
    remoteId: remoteId ?? this.remoteId,
    tripId: tripId ?? this.tripId,
    title: title ?? this.title,
    subtitle: subtitle.present ? subtitle.value : this.subtitle,
    content: content.present ? content.value : this.content,
    type: type ?? this.type,
    time: time ?? this.time,
    sortOrder: sortOrder ?? this.sortOrder,
    locationName: locationName.present ? locationName.value : this.locationName,
    iconName: iconName.present ? iconName.value : this.iconName,
    imageUrls: imageUrls.present ? imageUrls.value : this.imageUrls,
    personalInfoJson: personalInfoJson.present
        ? personalInfoJson.value
        : this.personalInfoJson,
    lastUpdated: lastUpdated.present ? lastUpdated.value : this.lastUpdated,
  );
  Activity copyWithCompanion(ActivitiesCompanion data) {
    return Activity(
      id: data.id.present ? data.id.value : this.id,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      title: data.title.present ? data.title.value : this.title,
      subtitle: data.subtitle.present ? data.subtitle.value : this.subtitle,
      content: data.content.present ? data.content.value : this.content,
      type: data.type.present ? data.type.value : this.type,
      time: data.time.present ? data.time.value : this.time,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      locationName: data.locationName.present
          ? data.locationName.value
          : this.locationName,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      imageUrls: data.imageUrls.present ? data.imageUrls.value : this.imageUrls,
      personalInfoJson: data.personalInfoJson.present
          ? data.personalInfoJson.value
          : this.personalInfoJson,
      lastUpdated: data.lastUpdated.present
          ? data.lastUpdated.value
          : this.lastUpdated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Activity(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('tripId: $tripId, ')
          ..write('title: $title, ')
          ..write('subtitle: $subtitle, ')
          ..write('content: $content, ')
          ..write('type: $type, ')
          ..write('time: $time, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('locationName: $locationName, ')
          ..write('iconName: $iconName, ')
          ..write('imageUrls: $imageUrls, ')
          ..write('personalInfoJson: $personalInfoJson, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    remoteId,
    tripId,
    title,
    subtitle,
    content,
    type,
    time,
    sortOrder,
    locationName,
    iconName,
    imageUrls,
    personalInfoJson,
    lastUpdated,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Activity &&
          other.id == this.id &&
          other.remoteId == this.remoteId &&
          other.tripId == this.tripId &&
          other.title == this.title &&
          other.subtitle == this.subtitle &&
          other.content == this.content &&
          other.type == this.type &&
          other.time == this.time &&
          other.sortOrder == this.sortOrder &&
          other.locationName == this.locationName &&
          other.iconName == this.iconName &&
          other.imageUrls == this.imageUrls &&
          other.personalInfoJson == this.personalInfoJson &&
          other.lastUpdated == this.lastUpdated);
}

class ActivitiesCompanion extends UpdateCompanion<Activity> {
  final Value<int> id;
  final Value<String> remoteId;
  final Value<String> tripId;
  final Value<String> title;
  final Value<String?> subtitle;
  final Value<String?> content;
  final Value<String> type;
  final Value<String> time;
  final Value<int> sortOrder;
  final Value<String?> locationName;
  final Value<String?> iconName;
  final Value<String?> imageUrls;
  final Value<String?> personalInfoJson;
  final Value<DateTime?> lastUpdated;
  const ActivitiesCompanion({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.tripId = const Value.absent(),
    this.title = const Value.absent(),
    this.subtitle = const Value.absent(),
    this.content = const Value.absent(),
    this.type = const Value.absent(),
    this.time = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.locationName = const Value.absent(),
    this.iconName = const Value.absent(),
    this.imageUrls = const Value.absent(),
    this.personalInfoJson = const Value.absent(),
    this.lastUpdated = const Value.absent(),
  });
  ActivitiesCompanion.insert({
    this.id = const Value.absent(),
    required String remoteId,
    required String tripId,
    required String title,
    this.subtitle = const Value.absent(),
    this.content = const Value.absent(),
    required String type,
    required String time,
    required int sortOrder,
    this.locationName = const Value.absent(),
    this.iconName = const Value.absent(),
    this.imageUrls = const Value.absent(),
    this.personalInfoJson = const Value.absent(),
    this.lastUpdated = const Value.absent(),
  }) : remoteId = Value(remoteId),
       tripId = Value(tripId),
       title = Value(title),
       type = Value(type),
       time = Value(time),
       sortOrder = Value(sortOrder);
  static Insertable<Activity> custom({
    Expression<int>? id,
    Expression<String>? remoteId,
    Expression<String>? tripId,
    Expression<String>? title,
    Expression<String>? subtitle,
    Expression<String>? content,
    Expression<String>? type,
    Expression<String>? time,
    Expression<int>? sortOrder,
    Expression<String>? locationName,
    Expression<String>? iconName,
    Expression<String>? imageUrls,
    Expression<String>? personalInfoJson,
    Expression<DateTime>? lastUpdated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (remoteId != null) 'remote_id': remoteId,
      if (tripId != null) 'trip_id': tripId,
      if (title != null) 'title': title,
      if (subtitle != null) 'subtitle': subtitle,
      if (content != null) 'content': content,
      if (type != null) 'type': type,
      if (time != null) 'time': time,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (locationName != null) 'location_name': locationName,
      if (iconName != null) 'icon_name': iconName,
      if (imageUrls != null) 'image_urls': imageUrls,
      if (personalInfoJson != null) 'personal_info_json': personalInfoJson,
      if (lastUpdated != null) 'last_updated': lastUpdated,
    });
  }

  ActivitiesCompanion copyWith({
    Value<int>? id,
    Value<String>? remoteId,
    Value<String>? tripId,
    Value<String>? title,
    Value<String?>? subtitle,
    Value<String?>? content,
    Value<String>? type,
    Value<String>? time,
    Value<int>? sortOrder,
    Value<String?>? locationName,
    Value<String?>? iconName,
    Value<String?>? imageUrls,
    Value<String?>? personalInfoJson,
    Value<DateTime?>? lastUpdated,
  }) {
    return ActivitiesCompanion(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      tripId: tripId ?? this.tripId,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      content: content ?? this.content,
      type: type ?? this.type,
      time: time ?? this.time,
      sortOrder: sortOrder ?? this.sortOrder,
      locationName: locationName ?? this.locationName,
      iconName: iconName ?? this.iconName,
      imageUrls: imageUrls ?? this.imageUrls,
      personalInfoJson: personalInfoJson ?? this.personalInfoJson,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (tripId.present) {
      map['trip_id'] = Variable<String>(tripId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (subtitle.present) {
      map['subtitle'] = Variable<String>(subtitle.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (time.present) {
      map['time'] = Variable<String>(time.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (locationName.present) {
      map['location_name'] = Variable<String>(locationName.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (imageUrls.present) {
      map['image_urls'] = Variable<String>(imageUrls.value);
    }
    if (personalInfoJson.present) {
      map['personal_info_json'] = Variable<String>(personalInfoJson.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivitiesCompanion(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('tripId: $tripId, ')
          ..write('title: $title, ')
          ..write('subtitle: $subtitle, ')
          ..write('content: $content, ')
          ..write('type: $type, ')
          ..write('time: $time, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('locationName: $locationName, ')
          ..write('iconName: $iconName, ')
          ..write('imageUrls: $imageUrls, ')
          ..write('personalInfoJson: $personalInfoJson, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses with TableInfo<$ExpensesTable, Expense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _remoteIdMeta = const VerificationMeta(
    'remoteId',
  );
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
    'remote_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<String> tripId = GeneratedColumn<String>(
    'trip_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountInBaseCurrencyMeta =
      const VerificationMeta('amountInBaseCurrency');
  @override
  late final GeneratedColumn<double> amountInBaseCurrency =
      GeneratedColumn<double>(
        'amount_in_base_currency',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    remoteId,
    tripId,
    amount,
    currency,
    amountInBaseCurrency,
    category,
    title,
    note,
    date,
    isSynced,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<Expense> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('remote_id')) {
      context.handle(
        _remoteIdMeta,
        remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta),
      );
    }
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('amount_in_base_currency')) {
      context.handle(
        _amountInBaseCurrencyMeta,
        amountInBaseCurrency.isAcceptableOrUnknown(
          data['amount_in_base_currency']!,
          _amountInBaseCurrencyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountInBaseCurrencyMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Expense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Expense(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      remoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_id'],
      ),
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      amountInBaseCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount_in_base_currency'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }
}

class Expense extends DataClass implements Insertable<Expense> {
  final int id;
  final String? remoteId;
  final String tripId;
  final double amount;
  final String currency;
  final double amountInBaseCurrency;
  final String category;
  final String title;
  final String? note;
  final DateTime date;
  final bool isSynced;
  final bool isDeleted;
  const Expense({
    required this.id,
    this.remoteId,
    required this.tripId,
    required this.amount,
    required this.currency,
    required this.amountInBaseCurrency,
    required this.category,
    required this.title,
    this.note,
    required this.date,
    required this.isSynced,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['trip_id'] = Variable<String>(tripId);
    map['amount'] = Variable<double>(amount);
    map['currency'] = Variable<String>(currency);
    map['amount_in_base_currency'] = Variable<double>(amountInBaseCurrency);
    map['category'] = Variable<String>(category);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['date'] = Variable<DateTime>(date);
    map['is_synced'] = Variable<bool>(isSynced);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      tripId: Value(tripId),
      amount: Value(amount),
      currency: Value(currency),
      amountInBaseCurrency: Value(amountInBaseCurrency),
      category: Value(category),
      title: Value(title),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      date: Value(date),
      isSynced: Value(isSynced),
      isDeleted: Value(isDeleted),
    );
  }

  factory Expense.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Expense(
      id: serializer.fromJson<int>(json['id']),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      tripId: serializer.fromJson<String>(json['tripId']),
      amount: serializer.fromJson<double>(json['amount']),
      currency: serializer.fromJson<String>(json['currency']),
      amountInBaseCurrency: serializer.fromJson<double>(
        json['amountInBaseCurrency'],
      ),
      category: serializer.fromJson<String>(json['category']),
      title: serializer.fromJson<String>(json['title']),
      note: serializer.fromJson<String?>(json['note']),
      date: serializer.fromJson<DateTime>(json['date']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'remoteId': serializer.toJson<String?>(remoteId),
      'tripId': serializer.toJson<String>(tripId),
      'amount': serializer.toJson<double>(amount),
      'currency': serializer.toJson<String>(currency),
      'amountInBaseCurrency': serializer.toJson<double>(amountInBaseCurrency),
      'category': serializer.toJson<String>(category),
      'title': serializer.toJson<String>(title),
      'note': serializer.toJson<String?>(note),
      'date': serializer.toJson<DateTime>(date),
      'isSynced': serializer.toJson<bool>(isSynced),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  Expense copyWith({
    int? id,
    Value<String?> remoteId = const Value.absent(),
    String? tripId,
    double? amount,
    String? currency,
    double? amountInBaseCurrency,
    String? category,
    String? title,
    Value<String?> note = const Value.absent(),
    DateTime? date,
    bool? isSynced,
    bool? isDeleted,
  }) => Expense(
    id: id ?? this.id,
    remoteId: remoteId.present ? remoteId.value : this.remoteId,
    tripId: tripId ?? this.tripId,
    amount: amount ?? this.amount,
    currency: currency ?? this.currency,
    amountInBaseCurrency: amountInBaseCurrency ?? this.amountInBaseCurrency,
    category: category ?? this.category,
    title: title ?? this.title,
    note: note.present ? note.value : this.note,
    date: date ?? this.date,
    isSynced: isSynced ?? this.isSynced,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  Expense copyWithCompanion(ExpensesCompanion data) {
    return Expense(
      id: data.id.present ? data.id.value : this.id,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      amount: data.amount.present ? data.amount.value : this.amount,
      currency: data.currency.present ? data.currency.value : this.currency,
      amountInBaseCurrency: data.amountInBaseCurrency.present
          ? data.amountInBaseCurrency.value
          : this.amountInBaseCurrency,
      category: data.category.present ? data.category.value : this.category,
      title: data.title.present ? data.title.value : this.title,
      note: data.note.present ? data.note.value : this.note,
      date: data.date.present ? data.date.value : this.date,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Expense(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('tripId: $tripId, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('amountInBaseCurrency: $amountInBaseCurrency, ')
          ..write('category: $category, ')
          ..write('title: $title, ')
          ..write('note: $note, ')
          ..write('date: $date, ')
          ..write('isSynced: $isSynced, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    remoteId,
    tripId,
    amount,
    currency,
    amountInBaseCurrency,
    category,
    title,
    note,
    date,
    isSynced,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Expense &&
          other.id == this.id &&
          other.remoteId == this.remoteId &&
          other.tripId == this.tripId &&
          other.amount == this.amount &&
          other.currency == this.currency &&
          other.amountInBaseCurrency == this.amountInBaseCurrency &&
          other.category == this.category &&
          other.title == this.title &&
          other.note == this.note &&
          other.date == this.date &&
          other.isSynced == this.isSynced &&
          other.isDeleted == this.isDeleted);
}

class ExpensesCompanion extends UpdateCompanion<Expense> {
  final Value<int> id;
  final Value<String?> remoteId;
  final Value<String> tripId;
  final Value<double> amount;
  final Value<String> currency;
  final Value<double> amountInBaseCurrency;
  final Value<String> category;
  final Value<String> title;
  final Value<String?> note;
  final Value<DateTime> date;
  final Value<bool> isSynced;
  final Value<bool> isDeleted;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.tripId = const Value.absent(),
    this.amount = const Value.absent(),
    this.currency = const Value.absent(),
    this.amountInBaseCurrency = const Value.absent(),
    this.category = const Value.absent(),
    this.title = const Value.absent(),
    this.note = const Value.absent(),
    this.date = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  ExpensesCompanion.insert({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    required String tripId,
    required double amount,
    required String currency,
    required double amountInBaseCurrency,
    required String category,
    required String title,
    this.note = const Value.absent(),
    required DateTime date,
    this.isSynced = const Value.absent(),
    this.isDeleted = const Value.absent(),
  }) : tripId = Value(tripId),
       amount = Value(amount),
       currency = Value(currency),
       amountInBaseCurrency = Value(amountInBaseCurrency),
       category = Value(category),
       title = Value(title),
       date = Value(date);
  static Insertable<Expense> custom({
    Expression<int>? id,
    Expression<String>? remoteId,
    Expression<String>? tripId,
    Expression<double>? amount,
    Expression<String>? currency,
    Expression<double>? amountInBaseCurrency,
    Expression<String>? category,
    Expression<String>? title,
    Expression<String>? note,
    Expression<DateTime>? date,
    Expression<bool>? isSynced,
    Expression<bool>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (remoteId != null) 'remote_id': remoteId,
      if (tripId != null) 'trip_id': tripId,
      if (amount != null) 'amount': amount,
      if (currency != null) 'currency': currency,
      if (amountInBaseCurrency != null)
        'amount_in_base_currency': amountInBaseCurrency,
      if (category != null) 'category': category,
      if (title != null) 'title': title,
      if (note != null) 'note': note,
      if (date != null) 'date': date,
      if (isSynced != null) 'is_synced': isSynced,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  ExpensesCompanion copyWith({
    Value<int>? id,
    Value<String?>? remoteId,
    Value<String>? tripId,
    Value<double>? amount,
    Value<String>? currency,
    Value<double>? amountInBaseCurrency,
    Value<String>? category,
    Value<String>? title,
    Value<String?>? note,
    Value<DateTime>? date,
    Value<bool>? isSynced,
    Value<bool>? isDeleted,
  }) {
    return ExpensesCompanion(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      tripId: tripId ?? this.tripId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      amountInBaseCurrency: amountInBaseCurrency ?? this.amountInBaseCurrency,
      category: category ?? this.category,
      title: title ?? this.title,
      note: note ?? this.note,
      date: date ?? this.date,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (tripId.present) {
      map['trip_id'] = Variable<String>(tripId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (amountInBaseCurrency.present) {
      map['amount_in_base_currency'] = Variable<double>(
        amountInBaseCurrency.value,
      );
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('tripId: $tripId, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('amountInBaseCurrency: $amountInBaseCurrency, ')
          ..write('category: $category, ')
          ..write('title: $title, ')
          ..write('note: $note, ')
          ..write('date: $date, ')
          ..write('isSynced: $isSynced, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $PackingsTable extends Packings with TableInfo<$PackingsTable, Packing> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PackingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _remoteIdMeta = const VerificationMeta(
    'remoteId',
  );
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
    'remote_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<String> tripId = GeneratedColumn<String>(
    'trip_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCheckedMeta = const VerificationMeta(
    'isChecked',
  );
  @override
  late final GeneratedColumn<bool> isChecked = GeneratedColumn<bool>(
    'is_checked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_checked" IN (0, 1))',
    ),
  );
  static const VerificationMeta _isCustomMeta = const VerificationMeta(
    'isCustom',
  );
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
    'is_custom',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_custom" IN (0, 1))',
    ),
  );
  static const VerificationMeta _lastUpdatedMeta = const VerificationMeta(
    'lastUpdated',
  );
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
    'last_updated',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    remoteId,
    tripId,
    userId,
    title,
    category,
    isChecked,
    isCustom,
    lastUpdated,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'packings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Packing> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('remote_id')) {
      context.handle(
        _remoteIdMeta,
        remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_remoteIdMeta);
    }
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('is_checked')) {
      context.handle(
        _isCheckedMeta,
        isChecked.isAcceptableOrUnknown(data['is_checked']!, _isCheckedMeta),
      );
    } else if (isInserting) {
      context.missing(_isCheckedMeta);
    }
    if (data.containsKey('is_custom')) {
      context.handle(
        _isCustomMeta,
        isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta),
      );
    } else if (isInserting) {
      context.missing(_isCustomMeta);
    }
    if (data.containsKey('last_updated')) {
      context.handle(
        _lastUpdatedMeta,
        lastUpdated.isAcceptableOrUnknown(
          data['last_updated']!,
          _lastUpdatedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Packing map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Packing(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      remoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_id'],
      )!,
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_id'],
      ),
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      isChecked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_checked'],
      )!,
      isCustom: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_custom'],
      )!,
      lastUpdated: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_updated'],
      ),
    );
  }

  @override
  $PackingsTable createAlias(String alias) {
    return $PackingsTable(attachedDatabase, alias);
  }
}

class Packing extends DataClass implements Insertable<Packing> {
  final int id;
  final String remoteId;
  final String? tripId;
  final String userId;
  final String title;
  final String category;
  final bool isChecked;
  final bool isCustom;
  final DateTime? lastUpdated;
  const Packing({
    required this.id,
    required this.remoteId,
    this.tripId,
    required this.userId,
    required this.title,
    required this.category,
    required this.isChecked,
    required this.isCustom,
    this.lastUpdated,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['remote_id'] = Variable<String>(remoteId);
    if (!nullToAbsent || tripId != null) {
      map['trip_id'] = Variable<String>(tripId);
    }
    map['user_id'] = Variable<String>(userId);
    map['title'] = Variable<String>(title);
    map['category'] = Variable<String>(category);
    map['is_checked'] = Variable<bool>(isChecked);
    map['is_custom'] = Variable<bool>(isCustom);
    if (!nullToAbsent || lastUpdated != null) {
      map['last_updated'] = Variable<DateTime>(lastUpdated);
    }
    return map;
  }

  PackingsCompanion toCompanion(bool nullToAbsent) {
    return PackingsCompanion(
      id: Value(id),
      remoteId: Value(remoteId),
      tripId: tripId == null && nullToAbsent
          ? const Value.absent()
          : Value(tripId),
      userId: Value(userId),
      title: Value(title),
      category: Value(category),
      isChecked: Value(isChecked),
      isCustom: Value(isCustom),
      lastUpdated: lastUpdated == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUpdated),
    );
  }

  factory Packing.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Packing(
      id: serializer.fromJson<int>(json['id']),
      remoteId: serializer.fromJson<String>(json['remoteId']),
      tripId: serializer.fromJson<String?>(json['tripId']),
      userId: serializer.fromJson<String>(json['userId']),
      title: serializer.fromJson<String>(json['title']),
      category: serializer.fromJson<String>(json['category']),
      isChecked: serializer.fromJson<bool>(json['isChecked']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
      lastUpdated: serializer.fromJson<DateTime?>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'remoteId': serializer.toJson<String>(remoteId),
      'tripId': serializer.toJson<String?>(tripId),
      'userId': serializer.toJson<String>(userId),
      'title': serializer.toJson<String>(title),
      'category': serializer.toJson<String>(category),
      'isChecked': serializer.toJson<bool>(isChecked),
      'isCustom': serializer.toJson<bool>(isCustom),
      'lastUpdated': serializer.toJson<DateTime?>(lastUpdated),
    };
  }

  Packing copyWith({
    int? id,
    String? remoteId,
    Value<String?> tripId = const Value.absent(),
    String? userId,
    String? title,
    String? category,
    bool? isChecked,
    bool? isCustom,
    Value<DateTime?> lastUpdated = const Value.absent(),
  }) => Packing(
    id: id ?? this.id,
    remoteId: remoteId ?? this.remoteId,
    tripId: tripId.present ? tripId.value : this.tripId,
    userId: userId ?? this.userId,
    title: title ?? this.title,
    category: category ?? this.category,
    isChecked: isChecked ?? this.isChecked,
    isCustom: isCustom ?? this.isCustom,
    lastUpdated: lastUpdated.present ? lastUpdated.value : this.lastUpdated,
  );
  Packing copyWithCompanion(PackingsCompanion data) {
    return Packing(
      id: data.id.present ? data.id.value : this.id,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      userId: data.userId.present ? data.userId.value : this.userId,
      title: data.title.present ? data.title.value : this.title,
      category: data.category.present ? data.category.value : this.category,
      isChecked: data.isChecked.present ? data.isChecked.value : this.isChecked,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
      lastUpdated: data.lastUpdated.present
          ? data.lastUpdated.value
          : this.lastUpdated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Packing(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('tripId: $tripId, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('isChecked: $isChecked, ')
          ..write('isCustom: $isCustom, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    remoteId,
    tripId,
    userId,
    title,
    category,
    isChecked,
    isCustom,
    lastUpdated,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Packing &&
          other.id == this.id &&
          other.remoteId == this.remoteId &&
          other.tripId == this.tripId &&
          other.userId == this.userId &&
          other.title == this.title &&
          other.category == this.category &&
          other.isChecked == this.isChecked &&
          other.isCustom == this.isCustom &&
          other.lastUpdated == this.lastUpdated);
}

class PackingsCompanion extends UpdateCompanion<Packing> {
  final Value<int> id;
  final Value<String> remoteId;
  final Value<String?> tripId;
  final Value<String> userId;
  final Value<String> title;
  final Value<String> category;
  final Value<bool> isChecked;
  final Value<bool> isCustom;
  final Value<DateTime?> lastUpdated;
  const PackingsCompanion({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.tripId = const Value.absent(),
    this.userId = const Value.absent(),
    this.title = const Value.absent(),
    this.category = const Value.absent(),
    this.isChecked = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.lastUpdated = const Value.absent(),
  });
  PackingsCompanion.insert({
    this.id = const Value.absent(),
    required String remoteId,
    this.tripId = const Value.absent(),
    required String userId,
    required String title,
    required String category,
    required bool isChecked,
    required bool isCustom,
    this.lastUpdated = const Value.absent(),
  }) : remoteId = Value(remoteId),
       userId = Value(userId),
       title = Value(title),
       category = Value(category),
       isChecked = Value(isChecked),
       isCustom = Value(isCustom);
  static Insertable<Packing> custom({
    Expression<int>? id,
    Expression<String>? remoteId,
    Expression<String>? tripId,
    Expression<String>? userId,
    Expression<String>? title,
    Expression<String>? category,
    Expression<bool>? isChecked,
    Expression<bool>? isCustom,
    Expression<DateTime>? lastUpdated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (remoteId != null) 'remote_id': remoteId,
      if (tripId != null) 'trip_id': tripId,
      if (userId != null) 'user_id': userId,
      if (title != null) 'title': title,
      if (category != null) 'category': category,
      if (isChecked != null) 'is_checked': isChecked,
      if (isCustom != null) 'is_custom': isCustom,
      if (lastUpdated != null) 'last_updated': lastUpdated,
    });
  }

  PackingsCompanion copyWith({
    Value<int>? id,
    Value<String>? remoteId,
    Value<String?>? tripId,
    Value<String>? userId,
    Value<String>? title,
    Value<String>? category,
    Value<bool>? isChecked,
    Value<bool>? isCustom,
    Value<DateTime?>? lastUpdated,
  }) {
    return PackingsCompanion(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      tripId: tripId ?? this.tripId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      category: category ?? this.category,
      isChecked: isChecked ?? this.isChecked,
      isCustom: isCustom ?? this.isCustom,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (tripId.present) {
      map['trip_id'] = Variable<String>(tripId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (isChecked.present) {
      map['is_checked'] = Variable<bool>(isChecked.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PackingsCompanion(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('tripId: $tripId, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('isChecked: $isChecked, ')
          ..write('isCustom: $isCustom, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TripsTable trips = $TripsTable(this);
  late final $ActivitiesTable activities = $ActivitiesTable(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final $PackingsTable packings = $PackingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    trips,
    activities,
    expenses,
    packings,
  ];
}

typedef $$TripsTableCreateCompanionBuilder =
    TripsCompanion Function({
      Value<int> id,
      required String remoteId,
      required String title,
      Value<String?> location,
      required DateTime startDate,
      required DateTime endDate,
      required int memberCount,
      required String status,
      Value<String?> iconName,
      Value<DateTime?> lastUpdated,
    });
typedef $$TripsTableUpdateCompanionBuilder =
    TripsCompanion Function({
      Value<int> id,
      Value<String> remoteId,
      Value<String> title,
      Value<String?> location,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<int> memberCount,
      Value<String> status,
      Value<String?> iconName,
      Value<DateTime?> lastUpdated,
    });

class $$TripsTableFilterComposer extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get memberCount => $composableBuilder(
    column: $table.memberCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconName => $composableBuilder(
    column: $table.iconName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TripsTableOrderingComposer
    extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get memberCount => $composableBuilder(
    column: $table.memberCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconName => $composableBuilder(
    column: $table.iconName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TripsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<int> get memberCount => $composableBuilder(
    column: $table.memberCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get iconName =>
      $composableBuilder(column: $table.iconName, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => column,
  );
}

class $$TripsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TripsTable,
          Trip,
          $$TripsTableFilterComposer,
          $$TripsTableOrderingComposer,
          $$TripsTableAnnotationComposer,
          $$TripsTableCreateCompanionBuilder,
          $$TripsTableUpdateCompanionBuilder,
          (Trip, BaseReferences<_$AppDatabase, $TripsTable, Trip>),
          Trip,
          PrefetchHooks Function()
        > {
  $$TripsTableTableManager(_$AppDatabase db, $TripsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TripsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TripsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TripsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> remoteId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<int> memberCount = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> iconName = const Value.absent(),
                Value<DateTime?> lastUpdated = const Value.absent(),
              }) => TripsCompanion(
                id: id,
                remoteId: remoteId,
                title: title,
                location: location,
                startDate: startDate,
                endDate: endDate,
                memberCount: memberCount,
                status: status,
                iconName: iconName,
                lastUpdated: lastUpdated,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String remoteId,
                required String title,
                Value<String?> location = const Value.absent(),
                required DateTime startDate,
                required DateTime endDate,
                required int memberCount,
                required String status,
                Value<String?> iconName = const Value.absent(),
                Value<DateTime?> lastUpdated = const Value.absent(),
              }) => TripsCompanion.insert(
                id: id,
                remoteId: remoteId,
                title: title,
                location: location,
                startDate: startDate,
                endDate: endDate,
                memberCount: memberCount,
                status: status,
                iconName: iconName,
                lastUpdated: lastUpdated,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TripsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TripsTable,
      Trip,
      $$TripsTableFilterComposer,
      $$TripsTableOrderingComposer,
      $$TripsTableAnnotationComposer,
      $$TripsTableCreateCompanionBuilder,
      $$TripsTableUpdateCompanionBuilder,
      (Trip, BaseReferences<_$AppDatabase, $TripsTable, Trip>),
      Trip,
      PrefetchHooks Function()
    >;
typedef $$ActivitiesTableCreateCompanionBuilder =
    ActivitiesCompanion Function({
      Value<int> id,
      required String remoteId,
      required String tripId,
      required String title,
      Value<String?> subtitle,
      Value<String?> content,
      required String type,
      required String time,
      required int sortOrder,
      Value<String?> locationName,
      Value<String?> iconName,
      Value<String?> imageUrls,
      Value<String?> personalInfoJson,
      Value<DateTime?> lastUpdated,
    });
typedef $$ActivitiesTableUpdateCompanionBuilder =
    ActivitiesCompanion Function({
      Value<int> id,
      Value<String> remoteId,
      Value<String> tripId,
      Value<String> title,
      Value<String?> subtitle,
      Value<String?> content,
      Value<String> type,
      Value<String> time,
      Value<int> sortOrder,
      Value<String?> locationName,
      Value<String?> iconName,
      Value<String?> imageUrls,
      Value<String?> personalInfoJson,
      Value<DateTime?> lastUpdated,
    });

class $$ActivitiesTableFilterComposer
    extends Composer<_$AppDatabase, $ActivitiesTable> {
  $$ActivitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tripId => $composableBuilder(
    column: $table.tripId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subtitle => $composableBuilder(
    column: $table.subtitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locationName => $composableBuilder(
    column: $table.locationName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconName => $composableBuilder(
    column: $table.iconName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrls => $composableBuilder(
    column: $table.imageUrls,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get personalInfoJson => $composableBuilder(
    column: $table.personalInfoJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActivitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivitiesTable> {
  $$ActivitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tripId => $composableBuilder(
    column: $table.tripId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subtitle => $composableBuilder(
    column: $table.subtitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locationName => $composableBuilder(
    column: $table.locationName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconName => $composableBuilder(
    column: $table.iconName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrls => $composableBuilder(
    column: $table.imageUrls,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get personalInfoJson => $composableBuilder(
    column: $table.personalInfoJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActivitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivitiesTable> {
  $$ActivitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<String> get tripId =>
      $composableBuilder(column: $table.tripId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get subtitle =>
      $composableBuilder(column: $table.subtitle, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get locationName => $composableBuilder(
    column: $table.locationName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get iconName =>
      $composableBuilder(column: $table.iconName, builder: (column) => column);

  GeneratedColumn<String> get imageUrls =>
      $composableBuilder(column: $table.imageUrls, builder: (column) => column);

  GeneratedColumn<String> get personalInfoJson => $composableBuilder(
    column: $table.personalInfoJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => column,
  );
}

class $$ActivitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivitiesTable,
          Activity,
          $$ActivitiesTableFilterComposer,
          $$ActivitiesTableOrderingComposer,
          $$ActivitiesTableAnnotationComposer,
          $$ActivitiesTableCreateCompanionBuilder,
          $$ActivitiesTableUpdateCompanionBuilder,
          (Activity, BaseReferences<_$AppDatabase, $ActivitiesTable, Activity>),
          Activity,
          PrefetchHooks Function()
        > {
  $$ActivitiesTableTableManager(_$AppDatabase db, $ActivitiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> remoteId = const Value.absent(),
                Value<String> tripId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> subtitle = const Value.absent(),
                Value<String?> content = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> time = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String?> locationName = const Value.absent(),
                Value<String?> iconName = const Value.absent(),
                Value<String?> imageUrls = const Value.absent(),
                Value<String?> personalInfoJson = const Value.absent(),
                Value<DateTime?> lastUpdated = const Value.absent(),
              }) => ActivitiesCompanion(
                id: id,
                remoteId: remoteId,
                tripId: tripId,
                title: title,
                subtitle: subtitle,
                content: content,
                type: type,
                time: time,
                sortOrder: sortOrder,
                locationName: locationName,
                iconName: iconName,
                imageUrls: imageUrls,
                personalInfoJson: personalInfoJson,
                lastUpdated: lastUpdated,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String remoteId,
                required String tripId,
                required String title,
                Value<String?> subtitle = const Value.absent(),
                Value<String?> content = const Value.absent(),
                required String type,
                required String time,
                required int sortOrder,
                Value<String?> locationName = const Value.absent(),
                Value<String?> iconName = const Value.absent(),
                Value<String?> imageUrls = const Value.absent(),
                Value<String?> personalInfoJson = const Value.absent(),
                Value<DateTime?> lastUpdated = const Value.absent(),
              }) => ActivitiesCompanion.insert(
                id: id,
                remoteId: remoteId,
                tripId: tripId,
                title: title,
                subtitle: subtitle,
                content: content,
                type: type,
                time: time,
                sortOrder: sortOrder,
                locationName: locationName,
                iconName: iconName,
                imageUrls: imageUrls,
                personalInfoJson: personalInfoJson,
                lastUpdated: lastUpdated,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActivitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivitiesTable,
      Activity,
      $$ActivitiesTableFilterComposer,
      $$ActivitiesTableOrderingComposer,
      $$ActivitiesTableAnnotationComposer,
      $$ActivitiesTableCreateCompanionBuilder,
      $$ActivitiesTableUpdateCompanionBuilder,
      (Activity, BaseReferences<_$AppDatabase, $ActivitiesTable, Activity>),
      Activity,
      PrefetchHooks Function()
    >;
typedef $$ExpensesTableCreateCompanionBuilder =
    ExpensesCompanion Function({
      Value<int> id,
      Value<String?> remoteId,
      required String tripId,
      required double amount,
      required String currency,
      required double amountInBaseCurrency,
      required String category,
      required String title,
      Value<String?> note,
      required DateTime date,
      Value<bool> isSynced,
      Value<bool> isDeleted,
    });
typedef $$ExpensesTableUpdateCompanionBuilder =
    ExpensesCompanion Function({
      Value<int> id,
      Value<String?> remoteId,
      Value<String> tripId,
      Value<double> amount,
      Value<String> currency,
      Value<double> amountInBaseCurrency,
      Value<String> category,
      Value<String> title,
      Value<String?> note,
      Value<DateTime> date,
      Value<bool> isSynced,
      Value<bool> isDeleted,
    });

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tripId => $composableBuilder(
    column: $table.tripId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amountInBaseCurrency => $composableBuilder(
    column: $table.amountInBaseCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tripId => $composableBuilder(
    column: $table.tripId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amountInBaseCurrency => $composableBuilder(
    column: $table.amountInBaseCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<String> get tripId =>
      $composableBuilder(column: $table.tripId, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<double> get amountInBaseCurrency => $composableBuilder(
    column: $table.amountInBaseCurrency,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$ExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpensesTable,
          Expense,
          $$ExpensesTableFilterComposer,
          $$ExpensesTableOrderingComposer,
          $$ExpensesTableAnnotationComposer,
          $$ExpensesTableCreateCompanionBuilder,
          $$ExpensesTableUpdateCompanionBuilder,
          (Expense, BaseReferences<_$AppDatabase, $ExpensesTable, Expense>),
          Expense,
          PrefetchHooks Function()
        > {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                Value<String> tripId = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<double> amountInBaseCurrency = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
              }) => ExpensesCompanion(
                id: id,
                remoteId: remoteId,
                tripId: tripId,
                amount: amount,
                currency: currency,
                amountInBaseCurrency: amountInBaseCurrency,
                category: category,
                title: title,
                note: note,
                date: date,
                isSynced: isSynced,
                isDeleted: isDeleted,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                required String tripId,
                required double amount,
                required String currency,
                required double amountInBaseCurrency,
                required String category,
                required String title,
                Value<String?> note = const Value.absent(),
                required DateTime date,
                Value<bool> isSynced = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
              }) => ExpensesCompanion.insert(
                id: id,
                remoteId: remoteId,
                tripId: tripId,
                amount: amount,
                currency: currency,
                amountInBaseCurrency: amountInBaseCurrency,
                category: category,
                title: title,
                note: note,
                date: date,
                isSynced: isSynced,
                isDeleted: isDeleted,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpensesTable,
      Expense,
      $$ExpensesTableFilterComposer,
      $$ExpensesTableOrderingComposer,
      $$ExpensesTableAnnotationComposer,
      $$ExpensesTableCreateCompanionBuilder,
      $$ExpensesTableUpdateCompanionBuilder,
      (Expense, BaseReferences<_$AppDatabase, $ExpensesTable, Expense>),
      Expense,
      PrefetchHooks Function()
    >;
typedef $$PackingsTableCreateCompanionBuilder =
    PackingsCompanion Function({
      Value<int> id,
      required String remoteId,
      Value<String?> tripId,
      required String userId,
      required String title,
      required String category,
      required bool isChecked,
      required bool isCustom,
      Value<DateTime?> lastUpdated,
    });
typedef $$PackingsTableUpdateCompanionBuilder =
    PackingsCompanion Function({
      Value<int> id,
      Value<String> remoteId,
      Value<String?> tripId,
      Value<String> userId,
      Value<String> title,
      Value<String> category,
      Value<bool> isChecked,
      Value<bool> isCustom,
      Value<DateTime?> lastUpdated,
    });

class $$PackingsTableFilterComposer
    extends Composer<_$AppDatabase, $PackingsTable> {
  $$PackingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tripId => $composableBuilder(
    column: $table.tripId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isChecked => $composableBuilder(
    column: $table.isChecked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PackingsTableOrderingComposer
    extends Composer<_$AppDatabase, $PackingsTable> {
  $$PackingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tripId => $composableBuilder(
    column: $table.tripId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isChecked => $composableBuilder(
    column: $table.isChecked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PackingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PackingsTable> {
  $$PackingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<String> get tripId =>
      $composableBuilder(column: $table.tripId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<bool> get isChecked =>
      $composableBuilder(column: $table.isChecked, builder: (column) => column);

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => column,
  );
}

class $$PackingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PackingsTable,
          Packing,
          $$PackingsTableFilterComposer,
          $$PackingsTableOrderingComposer,
          $$PackingsTableAnnotationComposer,
          $$PackingsTableCreateCompanionBuilder,
          $$PackingsTableUpdateCompanionBuilder,
          (Packing, BaseReferences<_$AppDatabase, $PackingsTable, Packing>),
          Packing,
          PrefetchHooks Function()
        > {
  $$PackingsTableTableManager(_$AppDatabase db, $PackingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PackingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PackingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PackingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> remoteId = const Value.absent(),
                Value<String?> tripId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<bool> isChecked = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
                Value<DateTime?> lastUpdated = const Value.absent(),
              }) => PackingsCompanion(
                id: id,
                remoteId: remoteId,
                tripId: tripId,
                userId: userId,
                title: title,
                category: category,
                isChecked: isChecked,
                isCustom: isCustom,
                lastUpdated: lastUpdated,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String remoteId,
                Value<String?> tripId = const Value.absent(),
                required String userId,
                required String title,
                required String category,
                required bool isChecked,
                required bool isCustom,
                Value<DateTime?> lastUpdated = const Value.absent(),
              }) => PackingsCompanion.insert(
                id: id,
                remoteId: remoteId,
                tripId: tripId,
                userId: userId,
                title: title,
                category: category,
                isChecked: isChecked,
                isCustom: isCustom,
                lastUpdated: lastUpdated,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PackingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PackingsTable,
      Packing,
      $$PackingsTableFilterComposer,
      $$PackingsTableOrderingComposer,
      $$PackingsTableAnnotationComposer,
      $$PackingsTableCreateCompanionBuilder,
      $$PackingsTableUpdateCompanionBuilder,
      (Packing, BaseReferences<_$AppDatabase, $PackingsTable, Packing>),
      Packing,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TripsTableTableManager get trips =>
      $$TripsTableTableManager(_db, _db.trips);
  $$ActivitiesTableTableManager get activities =>
      $$ActivitiesTableTableManager(_db, _db.activities);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
  $$PackingsTableTableManager get packings =>
      $$PackingsTableTableManager(_db, _db.packings);
}
