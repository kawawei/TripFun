/**
 * @file trip_collection.dart
 * @description 行程本地集合 / Trip local collection
 * @description_zh 用於 Isar 資料庫的行程實體，支援離線快取
 * @description_en Trip entity for Isar database, supporting offline caching
 */

import 'package:isar/isar.dart';

part 'trip_collection.g.dart';

@collection
class TripCollection {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String remoteId; // 後端 UUID

  late String title;
  String? location;
  late DateTime startDate;
  late DateTime endDate;
  late int memberCount;
  late String status;
  String? iconName;

  DateTime? lastUpdated; // 用於判斷快取是否過期
}
