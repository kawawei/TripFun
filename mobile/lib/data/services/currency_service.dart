import 'package:dio/dio.dart';

/**
 * @file currency_service.dart
 * @description 匯率 API 服務 / Currency API Service
 * @description_zh 負責與外部匯率 API 通訊，獲取即時數據
 */

class CurrencyService {
  final Dio _dio = Dio();
  static const String _baseUrl = 'https://open.er-api.com/v6/latest';

  /// 獲取特定幣別的匯率表 / Fetch exchange rates for a specific currency
  Future<Map<String, dynamic>?> getExchangeRates(String baseCurrency) async {
    try {
      final response = await _dio.get('$_baseUrl/$baseCurrency');
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('匯率抓取失敗: $e');
      return null;
    }
  }
}
