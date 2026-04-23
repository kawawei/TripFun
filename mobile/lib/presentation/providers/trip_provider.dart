/**
 * @file trip_provider.dart
 * @description 行程狀態管理 / Trip state management
 * @description_zh 管理從後端獲取的行程清單狀態
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/trip.dart';
import '../../data/services/trip_service.dart';

final tripServiceProvider = Provider((ref) => TripService());

final tripListProvider = StateNotifierProvider<TripListNotifier, AsyncValue<List<Trip>>>((ref) {
  final service = ref.watch(tripServiceProvider);
  return TripListNotifier(service);
});

class TripListNotifier extends StateNotifier<AsyncValue<List<Trip>>> {
  final TripService _service;

  TripListNotifier(this._service) : super(const AsyncValue.loading()) {
    fetchTrips();
  }

  Future<void> fetchTrips() async {
    state = const AsyncValue.loading();
    try {
      final trips = await _service.getTrips();
      state = AsyncValue.data(trips);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<bool> addTrip(Trip trip) async {
    try {
      final newTrip = await _service.createTrip(trip);
      if (newTrip != null) {
        // 更新本地狀態
        state.whenData((trips) {
          state = AsyncValue.data([newTrip, ...trips]);
        });
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
