/**
 * @file home_provider.dart
 * @description 首頁狀態管理 / Home page state management
 * @description_zh 提供行程列表數據的異步狀態管理
 * @description_en Provides async state management for the trip list
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/trip_entity.dart';
import '../../../../data/repositories/trip_repository_impl.dart';

final tripsProvider = FutureProvider<List<TripEntity>>((ref) async {
  final repository = ref.watch(tripRepositoryProvider);
  return repository.getTrips();
});
