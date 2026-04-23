/**
 * @file activity_dto.dart
 * @description 活動數據傳輸對象 / Activity Data Transfer Object
 * @description_zh 負責活動資料與後端 API 的 JSON 序列化
 * @description_en Handles JSON serialization for activity data from backend API
 */

import '../../domain/entities/activity_entity.dart';

class ActivityDto {
  final String id;
  final String tripId;
  final String time;
  final String title;
  final String? subtitle;
  final String? content;
  final String type;
  final String? iconName;
  final Map<String, dynamic>? personalInfo;
  final int sortOrder;
  final String? locationName;
  final double? latitude;
  final double? longitude;

  ActivityDto({
    required this.id,
    required this.tripId,
    required this.time,
    required this.title,
    this.subtitle,
    this.content,
    required this.type,
    this.iconName,
    this.personalInfo,
    required this.sortOrder,
    this.locationName,
    this.latitude,
    this.longitude,
  });

  factory ActivityDto.fromJson(Map<String, dynamic> json) {
    return ActivityDto(
      id: json['id'] as String,
      tripId: json['trip_id'] as String,
      time: json['time'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      content: json['content'] as String?,
      type: json['type'] as String,
      iconName: json['icon_name'] as String?,
      personalInfo: json['personal_info'] as Map<String, dynamic>?,
      sortOrder: json['sort_order'] as int? ?? 0,
      locationName: json['location_name'] as String?,
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
    );
  }

  ActivityEntity toEntity() {
    return ActivityEntity(
      id: id,
      tripId: tripId,
      time: time,
      title: title,
      subtitle: subtitle,
      content: content,
      type: type,
      iconName: iconName,
      personalInfo: personalInfo,
      sortOrder: sortOrder,
      locationName: locationName,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
