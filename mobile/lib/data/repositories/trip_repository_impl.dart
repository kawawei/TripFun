/**
 * @file trip_repository_impl.dart
 * @description 行程倉庫實作 / Trip repository implementation
 * @description_zh 實作從 API 獲取行程數據並轉換為領域模型，支援 Drift (SQLite) 離線快取
 * @description_en Implements fetching trip data from API and converting to domain models, supporting Drift (SQLite) offline caching
 */

import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import '../../domain/entities/trip_entity.dart';
import '../../domain/entities/activity_entity.dart';
import '../../domain/repositories/trip_repository.dart';
import '../dtos/trip_dto.dart';
import '../dtos/activity_dto.dart';
import '../local/app_database.dart';
import '../../core/providers/database_provider.dart';
import '../../core/providers/dio_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TripRepositoryImpl implements TripRepository {
  final Dio _dio;
  final AppDatabase _db;

  TripRepositoryImpl(this._dio, this._db);

  @override
  Future<List<TripEntity>> getTrips() async {
    try {
      // 1. 嘗試從網路獲取
      final response = await _dio.get('/trips');
      final List<dynamic> data = response.data;
      final trips = data.map((json) => TripDto.fromJson(json).toEntity()).toList();

      // 2. 成功後同步到本地快取 (背景執行)
      _cacheTrips(trips);

      return trips;
    } catch (e) {
      // 3. 網路失敗時，嘗試從本地快取讀取
      final cachedTrips = await _getCachedTrips();
      if (cachedTrips.isNotEmpty) {
        return cachedTrips;
      }
      rethrow;
    }
  }

  @override
  Future<TripEntity> getTripById(String id) async {
    try {
      final response = await _dio.get('/trips/$id');
      final trip = TripDto.fromJson(response.data).toEntity();
      
      // 單筆也要快取
      _cacheTrips([trip]);
      
      return trip;
    } catch (e) {
      final cached = await _getCachedTripById(id);
      if (cached != null) return cached;
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
        'memberCount': trip.memberCount,
        'status': trip.status,
        'icon_name': trip.iconName ?? 'map',
      });
      final newTrip = TripDto.fromJson(response.data).toEntity();
      _cacheTrips([newTrip]);
      return newTrip;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ActivityEntity>> getActivities(String tripId) async {
    try {
      final response = await _dio.get('/trips/$tripId/activities');
      final List<dynamic> data = response.data;
      final activities = data.map((json) => ActivityDto.fromJson(json).toEntity()).toList();

      // 同步到本地活動快取
      _cacheActivities(tripId, activities);

      return activities;
    } catch (e) {
      // 網路失敗讀取快取
      final cachedActivities = await _getCachedActivities(tripId);
      if (cachedActivities.isNotEmpty) {
        return cachedActivities;
      }
      rethrow;
    }
  }

  // ========================================
  // 本地快取邏輯 / Local Cache Logic
  // ========================================

  Future<void> _cacheTrips(List<TripEntity> trips) async {
    if (kIsWeb) return; // Web 端跳過本地快取
    
    await _db.batch((batch) {
      for (var trip in trips) {
        batch.insert(
          _db.trips,
          TripsCompanion.insert(
            remoteId: trip.id,
            title: trip.title,
            location: Value(trip.location),
            startDate: trip.startDate,
            endDate: trip.endDate,
            memberCount: trip.memberCount,
            status: trip.status,
            iconName: Value(trip.iconName),
            lastUpdated: Value(DateTime.now()),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  Future<List<TripEntity>> _getCachedTrips() async {
    if (kIsWeb) return [];
    final rows = await _db.select(_db.trips).get();
    return rows.map((c) => TripEntity(
      id: c.remoteId,
      title: c.title,
      location: c.location,
      startDate: c.startDate,
      endDate: c.endDate,
      memberCount: c.memberCount,
      status: c.status,
      iconName: c.iconName,
    )).toList();
  }

  Future<TripEntity?> _getCachedTripById(String id) async {
    if (kIsWeb) return null;
    final query = _db.select(_db.trips)..where((t) => t.remoteId.equals(id));
    final c = await query.getSingleOrNull();
    if (c == null) return null;
    return TripEntity(
      id: c.remoteId,
      title: c.title,
      location: c.location,
      startDate: c.startDate,
      endDate: c.endDate,
      memberCount: c.memberCount,
      status: c.status,
      iconName: c.iconName,
    );
  }

  Future<void> _cacheActivities(String tripId, List<ActivityEntity> activities) async {
    if (kIsWeb) return;
    
    // 先刪除該行程在本地的舊活動
    final deleteQuery = _db.delete(_db.activities)..where((t) => t.tripId.equals(tripId));
    await deleteQuery.go();
    
    await _db.batch((batch) {
      for (var act in activities) {
        batch.insert(
          _db.activities,
          ActivitiesCompanion.insert(
            remoteId: act.id,
            tripId: tripId,
            title: act.title,
            subtitle: Value(act.subtitle),
            content: Value(act.content),
            type: act.type,
            time: act.time,
            sortOrder: act.sortOrder,
            locationName: Value(act.locationName),
            iconName: Value(act.iconName),
            imageUrls: Value(act.imageUrls != null ? jsonEncode(act.imageUrls) : null),
            personalInfoJson: Value(act.personalInfo != null ? jsonEncode(act.personalInfo) : null),
            lastUpdated: Value(DateTime.now()),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  Future<List<ActivityEntity>> _getCachedActivities(String tripId) async {
    if (kIsWeb) return [];
    final query = _db.select(_db.activities)
      ..where((t) => t.tripId.equals(tripId))
      ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]);
    
    final rows = await query.get();
    
    return rows.map((c) {
      Map<String, dynamic>? personalInfo;
      if (c.personalInfoJson != null) {
        try {
          personalInfo = jsonDecode(c.personalInfoJson!) as Map<String, dynamic>;
        } catch (_) {}
      }
      
      List<String>? imageUrls;
      if (c.imageUrls != null) {
        try {
          imageUrls = List<String>.from(jsonDecode(c.imageUrls!));
        } catch (_) {}
      }

      return ActivityEntity(
        id: c.remoteId,
        tripId: c.tripId,
        title: c.title,
        subtitle: c.subtitle,
        content: c.content,
        type: c.type,
        time: c.time,
        sortOrder: c.sortOrder,
        locationName: c.locationName,
        iconName: c.iconName,
        imageUrls: imageUrls,
        personalInfo: personalInfo,
      );
    }).toList();
  }
}

final tripRepositoryProvider = Provider<TripRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final db = ref.watch(databaseProvider);
  return TripRepositoryImpl(dio, db);
});
