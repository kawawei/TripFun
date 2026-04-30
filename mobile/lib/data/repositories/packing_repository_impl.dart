/**
 * @file packing_repository_impl.dart
 * @description 行李清單倉庫實作 / Packing repository implementation
 * @description_zh 實作從 API 獲取行李數據並支援 Drift (SQLite) 離線快取
 * @description_en Implements fetching packing data from API with Drift (SQLite) offline caching
 */

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:drift/drift.dart';
import '../services/packing_service.dart';
import '../models/packing_item.dart';
import '../local/app_database.dart';
import '../../core/providers/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PackingRepositoryImpl {
  final PackingService _service;
  final AppDatabase _db;

  PackingRepositoryImpl(this._service, this._db);

  /// 獲取行李清單 (支援快取)
  Future<List<PackingItem>> getPackingList(String userId, {String? tripId}) async {
    try {
      // 1. 嘗試從網路獲取最新狀態
      final items = await _service.getPackingList(userId, tripId: tripId);
      
      // 2. 獲取成功則更新快取
      if (items.isNotEmpty) {
        _cachePackingItems(userId, tripId, items);
      }
      
      return items;
    } catch (e) {
      // 3. 失敗則讀取本地快取
      final cached = await _getCachedPackingItems(userId, tripId);
      if (cached.isNotEmpty) return cached;
      rethrow;
    }
  }

  /// 更新勾選狀態
  Future<bool> toggleItemStatus(String userId, String itemId, bool isChecked, {String? tripId}) async {
    // 樂觀更新本地快取
    if (!kIsWeb) {
      await _updateLocalStatus(itemId, isChecked);
    }
    
    // 同步到後端
    return await _service.toggleItemStatus(userId, itemId, isChecked, tripId: tripId);
  }

  // ========================================
  // 私有輔助方法 / Private Helpers
  // ========================================

  Future<void> _cachePackingItems(String userId, String? tripId, List<PackingItem> items) async {
    if (kIsWeb) return;
    
    await _db.batch((batch) {
      // 清除舊快取 (針對特定用戶與行程)
      batch.deleteWhere(_db.packings, (t) => t.userId.equals(userId) & (tripId != null ? t.tripId.equals(tripId) : t.tripId.isNull()));
      
      for (var item in items) {
        batch.insert(
          _db.packings,
          PackingsCompanion.insert(
            remoteId: item.id,
            tripId: Value(tripId),
            userId: userId,
            title: item.title,
            category: item.category,
            isChecked: item.isChecked,
            isCustom: item.isCustom,
            lastUpdated: Value(DateTime.now()),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  Future<List<PackingItem>> _getCachedPackingItems(String userId, String? tripId) async {
    if (kIsWeb) return [];
    final query = _db.select(_db.packings)
      ..where((t) => t.userId.equals(userId) & (tripId != null ? t.tripId.equals(tripId) : t.tripId.isNull()));
    
    final rows = await query.get();
    
    return rows.map((c) => PackingItem(
      id: c.remoteId,
      title: c.title,
      category: c.category,
      isChecked: c.isChecked,
      isCustom: c.isCustom,
    )).toList();
  }

  Future<void> _updateLocalStatus(String remoteId, bool isChecked) async {
    if (kIsWeb) return;
    final updateQuery = _db.update(_db.packings)..where((t) => t.remoteId.equals(remoteId));
    await updateQuery.write(PackingsCompanion(isChecked: Value(isChecked)));
  }
}

final packingRepositoryProvider = Provider<PackingRepositoryImpl>((ref) {
  final db = ref.watch(databaseProvider);
  return PackingRepositoryImpl(PackingService(), db);
});
