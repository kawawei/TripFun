/// @file trip_entity.dart
/// @description 行程領域模型 / Trip domain entity
/// @description_zh 定義行程的核心業務資料結構
/// @description_en Defines the core business data structure of a trip
library;

class TripEntity {
  final String id;
  final String title;
  final String? location;
  final DateTime startDate;
  final DateTime endDate;
  final int memberCount;
  final String? iconName;
  final int? colorValue;
  final String status;

  TripEntity({
    required this.id,
    required this.title,
    this.location,
    required this.startDate,
    required this.endDate,
    this.memberCount = 1,
    this.iconName,
    this.colorValue,
    this.status = 'ACTIVE',
  });

  // 輔助方法：計算旅程天數 / Helper: Calculate trip duration in days
  int get durationDays => endDate.difference(startDate).inDays + 1;
}
