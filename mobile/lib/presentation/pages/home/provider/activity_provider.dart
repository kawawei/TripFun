/**
 * @file activity_provider.dart
 * @description 活動列表狀態管理 / Activity list state management
 * @description_zh 根據行程 ID 提供活動列表數據的異步狀態管理
 * @description_en Provides async state management for activities based on trip ID
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/activity_entity.dart';
import '../../../../data/repositories/trip_repository_impl.dart';

final activitiesProvider = FutureProvider.family<List<ActivityEntity>, String>((ref, tripId) async {
  final repository = ref.watch(tripRepositoryProvider);
  return repository.getActivities(tripId);
});
