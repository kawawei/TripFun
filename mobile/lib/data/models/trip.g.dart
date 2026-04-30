// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TripImpl _$$TripImplFromJson(Map<String, dynamic> json) => _$TripImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      location: json['location'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      memberCount: (json['memberCount'] as num?)?.toInt() ?? 1,
      iconName: json['iconName'] as String?,
      colorValue: (json['colorValue'] as num?)?.toInt(),
      activities: (json['activities'] as List<dynamic>?)
              ?.map((e) => TripActivity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$TripImplToJson(_$TripImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'location': instance.location,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'memberCount': instance.memberCount,
      'iconName': instance.iconName,
      'colorValue': instance.colorValue,
      'activities': instance.activities,
    };

_$TripActivityImpl _$$TripActivityImplFromJson(Map<String, dynamic> json) =>
    _$TripActivityImpl(
      id: json['id'] as String,
      time: json['time'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      iconName: json['iconName'] as String,
      personalInfo: (json['personalInfo'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      isFirst: json['isFirst'] as bool? ?? false,
      isLast: json['isLast'] as bool? ?? false,
    );

Map<String, dynamic> _$$TripActivityImplToJson(_$TripActivityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'time': instance.time,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'iconName': instance.iconName,
      'personalInfo': instance.personalInfo,
      'isFirst': instance.isFirst,
      'isLast': instance.isLast,
    };
