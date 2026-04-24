/**
 * @file packing_service.dart
 * @description 行李清單 API 服務 / Packing List API Service
 * @description_zh 負責與後端通訊，處理行李清單的抓取與狀態更新
 * @description_en Handles communication with the backend for fetching packing list and updating status
 */

import 'package:dio/dio.dart';
import '../models/packing_item.dart';
import 'trip_service.dart'; // 利用相同的 baseUrl

class PackingService {
  final Dio _dio;
  
  PackingService() : _dio = Dio(BaseOptions(
    baseUrl: TripService.baseUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));

  /// 獲取清單 / Fetch packing list
  Future<List<PackingItem>> getPackingList(String userId, {String? tripId}) async {
    try {
      final response = await _dio.get('/trips/packing', queryParameters: {
        'userId': userId,
        if (tripId != null) 'tripId': tripId,
      });
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => PackingItem.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Fetch packing list error: $e');
      return [];
    }
  }

  /// 切換狀態 / Toggle check status
  Future<bool> toggleItemStatus(String userId, String itemId, bool isChecked, {String? tripId}) async {
    try {
      final response = await _dio.patch('/trips/packing/items/$itemId/status', data: {
        'userId': userId,
        'isChecked': isChecked,
        if (tripId != null) 'tripId': tripId,
      });
      return response.statusCode == 200;
    } catch (e) {
      print('Toggle packing status error: $e');
      return false;
    }
  }

  /// 新增項目 / Create item
  Future<PackingItem?> createItem(String title, String category, {String? tripId, String? userId}) async {
    try {
      final response = await _dio.post('/trips/packing/items', data: {
        'title': title,
        'category': category,
        'is_custom': true,
        'trip_id': tripId,
        'created_by': userId,
      });
      if (response.statusCode == 201 || response.statusCode == 200) {
        return PackingItem.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('Create packing item error: $e');
      return null;
    }
  }

  /// 刪除項目 / Delete item
  Future<bool> deleteItem(String itemId) async {
    try {
      final response = await _dio.delete('/trips/packing/items/$itemId');
      return response.statusCode == 200;
    } catch (e) {
      print('Delete packing item error: $e');
      return false;
    }
  }
}
