/**
 * @file database_provider.dart
 * @description 資料庫提供者 / Database provider
 * @description_zh 提供 AppDatabase 實例供全域使用
 * @description_en Provides AppDatabase instance for global use
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/local/app_database.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});
