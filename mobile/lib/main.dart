/// @file main.dart
/// @description 應用程式入口 / Application entry point
/// @description_zh 初始化全域狀態管理與套用自定義主題
/// @description_en Initializes global state management and applies custom themes
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'presentation/pages/main_screen.dart';
import 'presentation/pages/auth/login_page.dart';
import 'presentation/providers/auth_provider.dart';
import 'domain/entities/user_entity.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'data/local/isar_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化本地資料庫
  await IsarService.instance;
  
  tz.initializeTimeZones();
  
  // 初始化 SharedPreferences 並提早載入目前使用者
  final prefs = await SharedPreferences.getInstance();
  final savedId = prefs.getString('current_user_id');
  final savedName = prefs.getString('current_user_name');
  UserEntity? initialUser;
  if (savedId != null && savedName != null) {
    initialUser = UserEntity(id: savedId, name: savedName);
  }

  runApp(
    ProviderScope(
      overrides: [
        if (initialUser != null)
          authProvider.overrideWith((ref) => AuthNotifier(initialUser)),
      ],
      child: const TripFunApp(),
    ),
  );
}

class TripFunApp extends ConsumerWidget {
  const TripFunApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authProvider);

    return MaterialApp(
      title: 'TripFun',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: currentUser == null ? const LoginPage() : const MainScreen(),
    );
  }
}
