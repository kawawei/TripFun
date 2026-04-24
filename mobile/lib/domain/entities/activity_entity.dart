/**
 * @file activity_entity.dart
 * @description 活動領域模型 / Activity domain entity
 * @description_zh 定義行程每一站活動的核心業務資料結構
 * @description_en Defines the core business data structure of an activity in a trip
 */

class ActivityEntity {
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
  final List<String>? imageUrls;

  ActivityEntity({
    required this.id,
    required this.tripId,
    required this.time,
    required this.title,
    this.subtitle,
    this.content,
    required this.type,
    this.iconName,
    this.personalInfo,
    this.sortOrder = 0,
    this.locationName,
    this.latitude,
    this.longitude,
    this.imageUrls,
  });
}
