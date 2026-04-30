/**
 * @file trip_service.dart
 * @description 行程 API 服務 / Trip API Service
 * @description_zh 負責與後端通訊，處理行程的抓取與建立
 * @description_en Handles communication with the backend for fetching and creating trips
 */

import 'package:dio/dio.dart';
import '../models/trip.dart';

class TripService {
  final Dio _dio;
  
  // 測試伺服器後端地址 / Test server backend address
  // 根據 SDD 端口分配規範，伺服器後端映射端口為 8087
  static const String baseUrl = 'http://43.103.3.57:8087/api/v1';

  TripService() : _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));

  /// 獲取所有行程 / Fetch all trips
  Future<List<Trip>> getTrips() async {
    try {
      final response = await _dio.get('/trips');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Trip.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      // 在本地開發環境下，如果連接失敗可以打印日誌
      print('Fetch trips error: $e');
      return [];
    }
  }

  /// 建立新行程 / Create a new trip
  Future<Trip?> createTrip(Trip trip) async {
    try {
      final response = await _dio.post('/trips', data: trip.toJson());
      if (response.statusCode == 201 || response.statusCode == 200) {
        return Trip.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('Create trip error: $e');
      return null;
    }
  }
}
