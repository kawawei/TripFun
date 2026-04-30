/**
 * @file dio_provider.dart
 * @description Dio 網路請求客戶端提供者 / Dio network client provider
 * @description_zh 配置全域 Dio 實例，包含 BaseURL 與攔截器
 * @description_en Configures global Dio instance, including BaseURL and interceptors
 */

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      // 根據 Docker 映射，後端 API 在 9001 端口 / Per Docker mapping, backend API is on port 9001
      // 在 Android 模擬器中，localhost 是 10.0.2.2 / For Android emulator, use 10.0.2.2
      // 這裡暫時使用 localhost，實際開發可透過 .env 配置
      baseUrl: 'http://43.103.3.57:8087/api/v1', 
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // 為了避免每 3 秒輪詢造成終端機洗版，已將 LogInterceptor 完整移除

  return dio;
});
