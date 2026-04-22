/// @file trip_entity.dart
/// @description 行程領域模型 / Trip domain entity
/// @description_zh 定義行程的核心業務資料結構
/// @description_en Defines the core business data structure of a trip
library;

class TripEntity {
  final String id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final String? description;
  final String? countryCode; // 用於顯示國旗 Icon

  TripEntity({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    this.description,
    this.countryCode,
  });

  // 輔助方法：計算旅程天數
  int get durationDays => endDate.difference(startDate).inDays + 1;
}
