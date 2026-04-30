/**
 * @file packing_collection.dart
 * @description 行李清單本地集合 / Packing local collection
 * @description_zh 用於 Isar 資料庫的行李實體，支援離線核取與快取
 * @description_en Packing entity for Isar database, supporting offline checking and caching
 */

import 'package:isar/isar.dart';

part 'packing_collection.g.dart';

@collection
class PackingCollection {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String remoteId; // 後端 UUID

  @Index()
  String? tripId; // 所屬行程

  @Index()
  late String userId; // 使用者 ID (用於區分核取人)

  late String title;
  late String category;
  late bool isChecked;
  late bool isCustom;

  DateTime? lastUpdated;
}
