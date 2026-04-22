/// @file main.dart
/// @description 應用程式入口 / Application entry point
/// @description_zh 初始化全域狀態管理與套用自定義主題
/// @description_en Initializes global state management and applies custom themes
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'core/theme/app_theme.dart';
import 'presentation/widgets/create_trip_modal.dart';

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
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TripFun'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 使用 Lucide Icon 取代 Emoji，展現專業感
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LucideIcons.plane,
                  size: 64,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                '準備好開始新的冒險了嗎？',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                '建立你的第一個行程，邀請家人好友一起規劃。',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              FilledButton.icon(
                onPressed: () => CreateTripModal.show(context),
                icon: const Icon(LucideIcons.plus),
                label: const Text('建立行程'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
