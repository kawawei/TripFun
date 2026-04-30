/**
 * @file isar_service.dart
 * @description Isar 資料庫服務 / Isar database service
 * @description_zh 管理 Isar 資料庫實例的生命週期與初始化
 * @description_en Manages Isar database instance lifecycle and initialization
 */

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'collections/trip_collection.dart';
import 'collections/activity_collection.dart';
import 'collections/expense_collection.dart';
import 'collections/packing_collection.dart';

class IsarService {
  static Isar? _instance;

  static Future<Isar?> get instance async {
    if (kIsWeb) return null; // Web 端不支援 Isar 3.x，回傳 null
    if (_instance != null) return _instance!;
    
    final dir = await getApplicationDocumentsDirectory();
    _instance = await Isar.open(
      [
        TripCollectionSchema,
        ActivityCollectionSchema,
        ExpenseCollectionSchema,
        PackingCollectionSchema,
      ],
      directory: dir.path,
      inspector: true,
    );
    
    return _instance!;
  }

  // 關閉資料庫 (通常在 App 結束時調用，但 Flutter Web/Mobile 通常不嚴格要求)
  static Future<void> close() async {
    await _instance?.close();
    _instance = null;
  }
}
