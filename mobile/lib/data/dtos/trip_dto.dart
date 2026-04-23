/**
 * @file trip_dto.dart
 * @description 行程數據傳輸對象 / Trip Data Transfer Object
 * @description_zh 負責與後端 API 進行 JSON 序列化與反序列化
 * @description_en Handles JSON serialization and deserialization for backend API
 */

import '../../domain/entities/trip_entity.dart';

class TripDto {
  final String id;
  final String title;
  final String? location;
  final String startDate;
  final String endDate;
  final int memberCount;
  final String? iconName;
  final int? colorValue;
  final String status;

  TripDto({
    required this.id,
    required this.title,
    this.location,
    required this.startDate,
    required this.endDate,
    required this.memberCount,
    this.iconName,
    this.colorValue,
    required this.status,
  });

  factory TripDto.fromJson(Map<String, dynamic> json) {
    return TripDto(
      id: (json['id'] ?? '').toString(),
      title: json['title'] as String? ?? '未命名行程',
      location: json['location'] as String?,
      startDate: json['startDate'] as String? ?? DateTime.now().toIso8601String(),
      endDate: json['endDate'] as String? ?? DateTime.now().toIso8601String(),
      memberCount: (json['memberCount'] as num? ?? 1).toInt(),
      iconName: json['icon_name'] as String?,
      colorValue: json['color_value'] != null ? (json['color_value'] as num).toInt() : null,
      status: json['status'] as String? ?? 'ACTIVE',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'location': location,
      'startDate': startDate,
      'endDate': endDate,
      'memberCount': memberCount,
      'icon_name': iconName,
      'color_value': colorValue,
      'status': status,
    };
  }

  TripEntity toEntity() {
    return TripEntity(
      id: id,
      title: title,
      location: location,
      startDate: DateTime.parse(startDate).toLocal(),
      endDate: DateTime.parse(endDate).toLocal(),
      memberCount: memberCount,
      iconName: iconName,
      colorValue: colorValue,
      status: status,
    );
  }
}
