/**
 * @file activity_collection.dart
 * @description 活動本地集合 / Activity local collection
 * @description_zh 用於 Isar 資料庫的活動實體，支援離線快取
 * @description_en Activity entity for Isar database, supporting offline caching
 */

import 'package:isar/isar.dart';

part 'activity_collection.g.dart';

@collection
class ActivityCollection {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String remoteId; // 後端 UUID

  @Index()
  late String tripId; // 關聯的行程 ID

  late String title;
  String? subtitle;
  String? content;
  late String type; // TRANSPORT, FOOD, ACCOMMODATION, ATTRACTION
  late String time;
  late int sortOrder;
  String? locationName;
  String? iconName;
  
  List<String>? imageUrls;
  String? personalInfoJson; // 存放複雜的個人資訊 (JSON 字串)

  DateTime? lastUpdated;
}
