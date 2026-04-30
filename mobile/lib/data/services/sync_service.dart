/**
 * @file sync_service.dart
 * @description 全域同步服務 / Global sync service
 * @description_zh 負責在 App 啟動時預載所有行程、活動數據與圖檔，達成完整離線化體驗
 * @description_en Preloads all trips, activities, and images at startup for a complete offline experience
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../repositories/trip_repository_impl.dart';
import '../../presentation/providers/auth_provider.dart';

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(ref);
});

class SyncService {
  final Ref _ref;
  SyncService(this._ref);

  /// 執行完整同步
  Future<void> fullSync() async {
    final user = _ref.read(authProvider);
    if (user == null) return;

    print('Starting full offline sync...');

    try {
      // 1. 同步行程列表 (內部會存入 Drift)
      final trips = await _ref.read(tripRepositoryProvider).getTrips();
      
      for (var trip in trips) {
        // 2. 同步每個行程的活動細節 (內部會存入 Drift)
        final activities = await _ref.read(tripRepositoryProvider).getActivities(trip.id);
        
        // 3. 預下載活動圖檔
        for (var activity in activities) {
          if (activity.imageUrls != null && activity.imageUrls!.isNotEmpty) {
            for (var url in activity.imageUrls!) {
              try {
                // 使用 DefaultCacheManager 預先下載並快取圖檔
                // 這樣在離線時，CachedNetworkImage 就能直接從本地讀取
                await DefaultCacheManager().downloadFile(url);
                print('Pre-cached image: $url');
              } catch (e) {
                print('Failed to pre-cache image $url: $e');
              }
            }
          }
        }
      }
      
      print('Full offline sync completed successfully.');
    } catch (e) {
      print('Full offline sync failed: $e');
    }
  }
}
