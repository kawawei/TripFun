/// @file main.dart
/// @description 應用程式入口 / Application entry point
/// @description_zh 初始化全域狀態管理與套用自定義主題
/// @description_en Initializes global state management and applies custom themes
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'presentation/pages/main_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: TripFunApp(),
    ),
  );
}

class TripFunApp extends StatelessWidget {
  const TripFunApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TripFun',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainScreen(),
    );
  }
}
