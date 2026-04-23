/**
 * @file trip_repository_impl.dart
 * @description 行程倉庫實作 / Trip repository implementation
 * @description_zh 實作從 API 獲取行程數據並轉換為領域模型
 * @description_en Implements fetching trip data from API and converting to domain models
 */

import 'package:dio/dio.dart';
import '../../domain/entities/trip_entity.dart';
import '../../domain/entities/activity_entity.dart';
import '../../domain/repositories/trip_repository.dart';
import '../dtos/trip_dto.dart';
import '../dtos/activity_dto.dart';
import '../../core/providers/dio_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TripRepositoryImpl implements TripRepository {
  final Dio _dio;

  TripRepositoryImpl(this._dio);

  @override
  Future<List<TripEntity>> getTrips() async {
    try {
      final response = await _dio.get('/trips');
      final List<dynamic> data = response.data;
      return data.map((json) => TripDto.fromJson(json).toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TripEntity> getTripById(String id) async {
    try {
      final response = await _dio.get('/trips/$id');
      return TripDto.fromJson(response.data).toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TripEntity> createTrip(TripEntity trip) async {
    try {
      final response = await _dio.post('/trips', data: {
        'title': trip.title,
        'location': trip.location,
        'startDate': trip.startDate.toIso8601String(),
        'endDate': trip.endDate.toIso8601String(),
      });
      return TripDto.fromJson(response.data).toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ActivityEntity>> getActivities(String tripId) async {
    try {
      final response = await _dio.get('/trips/$tripId/activities');
      final List<dynamic> data = response.data;
      return data.map((json) => ActivityDto.fromJson(json).toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }
}

final tripRepositoryProvider = Provider<TripRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return TripRepositoryImpl(dio);
});
