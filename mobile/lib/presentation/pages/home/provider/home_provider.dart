/**
 * @file home_provider.dart
 * @description 首頁狀態管理 / Home page state management
 * @description_zh 提供行程列表數據的異步狀態管理
 * @description_en Provides async state management for the trip list
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/trip_entity.dart';
import '../../../../data/repositories/trip_repository_impl.dart';

final tripsProvider = AsyncNotifierProvider<TripsNotifier, List<TripEntity>>(() {
  return TripsNotifier();
});

class TripsNotifier extends AsyncNotifier<List<TripEntity>> {
  @override
  Future<List<TripEntity>> build() async {
    final repository = ref.watch(tripRepositoryProvider);
    return repository.getTrips();
  }

  Future<void> addTrip(TripEntity trip) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(tripRepositoryProvider);
      await repository.createTrip(trip);
      // 成功後刷新列表 / Refresh list after success
      ref.invalidateSelf();
      await future;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
