/**
 * @file packing_repository_impl.dart
 * @description 行李清單倉庫實作 / Packing repository implementation
 * @description_zh 實作從 API 獲取行李數據並支援 Isar 離線快取
 * @description_en Implements fetching packing data from API with Isar offline caching
 */

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:isar/isar.dart';
import '../services/packing_service.dart';
import '../models/packing_item.dart';
import '../local/collections/packing_collection.dart';
import '../local/isar_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PackingRepositoryImpl {
  final PackingService _service;

  PackingRepositoryImpl(this._service);

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
    final isar = await IsarService.instance;
    if (isar == null) return;
    await isar.writeTxn(() async {
      // 清除舊快取 (針對特定用戶與行程)
      await isar.packingCollections
          .filter()
          .userIdEqualTo(userId)
          .and()
          .tripIdEqualTo(tripId)
          .deleteAll();
      
      for (var item in items) {
        final collection = PackingCollection()
          ..remoteId = item.id
          ..tripId = tripId
          ..userId = userId
          ..title = item.title
          ..category = item.category
          ..isChecked = item.isChecked
          ..isCustom = item.isCustom
          ..lastUpdated = DateTime.now();
        
        await isar.packingCollections.putByRemoteId(collection);
      }
    });
  }

  Future<List<PackingItem>> _getCachedPackingItems(String userId, String? tripId) async {
    if (kIsWeb) return [];
    final isar = await IsarService.instance;
    if (isar == null) return [];
    final collections = await isar.packingCollections
        .filter()
        .userIdEqualTo(userId)
        .and()
        .tripIdEqualTo(tripId)
        .findAll();
    
    return collections.map((c) => PackingItem(
      id: c.remoteId,
      title: c.title,
      category: c.category,
      isChecked: c.isChecked,
      isCustom: c.isCustom,
    )).toList();
  }

  Future<void> _updateLocalStatus(String remoteId, bool isChecked) async {
    if (kIsWeb) return;
    final isar = await IsarService.instance;
    if (isar == null) return;
    await isar.writeTxn(() async {
      final collection = await isar.packingCollections.filter().remoteIdEqualTo(remoteId).findFirst();
      if (collection != null) {
        collection.isChecked = isChecked;
        await isar.packingCollections.putByRemoteId(collection);
      }
    });
  }
}

final packingRepositoryProvider = Provider<PackingRepositoryImpl>((ref) {
  // 目前 PackingService 被宣告在同層，這裡實例化
  return PackingRepositoryImpl(PackingService());
});
