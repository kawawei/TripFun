/**
 * @file expense_collection.dart
 * @description 支出本地集合 / Expense local collection
 * @description_zh 用於 Isar 資料庫的支出實體，支援離線儲存與同步標記
 * @description_en Expense entity for Isar database, supporting offline storage and sync flags
 */

import 'package:isar/isar.dart';

part 'expense_collection.g.dart';

@collection
class ExpenseCollection {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? remoteId; // 後端 UUID (如果是離線新增，此處為 null)

  @Index()
  late String tripId; // 關聯行程

  late double amount;
  late String currency;
  late double amountInBaseCurrency;
  late String category;
  late String title;
  String? note;
  late DateTime dateTime;

  @Index()
  bool isSynced = false; // 是否已同步至後端

  bool isDeleted = false; // 離線刪除標記 (Soft Delete)
}
