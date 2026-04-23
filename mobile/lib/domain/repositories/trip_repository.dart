/**
 * @file trip_repository.dart
 * @description 行程倉庫介面 / Trip repository interface
 * @description_zh 定義獲取行程數據的抽象方法
 * @description_en Defines abstract methods for fetching trip data
 */

import '../entities/trip_entity.dart';
import '../entities/activity_entity.dart';

abstract class TripRepository {
  Future<List<TripEntity>> getTrips();
  Future<TripEntity> getTripById(String id);
  Future<TripEntity> createTrip(TripEntity trip);
  Future<List<ActivityEntity>> getActivities(String tripId);
}
