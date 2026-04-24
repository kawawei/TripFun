/**
 * @file activity_provider.dart
 * @description 活動列表狀態管理 / Activity list state management
 * @description_zh 根據行程 ID 提供活動列表數據的異步狀態管理
 * @description_en Provides async state management for activities based on trip ID
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/activity_entity.dart';
import '../../../../data/repositories/trip_repository_impl.dart';

final activitiesProvider = StreamProvider.autoDispose.family<List<ActivityEntity>, String>((ref, tripId) async* {
  final repository = ref.watch(tripRepositoryProvider);
  
  // 首次立即返回當前數據 / Yield initial data immediately
  yield await repository.getActivities(tripId);
  
  // 每 3 秒輪詢一次 / Poll every 3 seconds for real-time updates
  while (true) {
    await Future.delayed(const Duration(seconds: 3));
    try {
      yield await repository.getActivities(tripId);
    } catch (e) {
      // 忽略錯誤以維持畫面狀態 / Ignore errors to keep current UI state
    }
  }
});
