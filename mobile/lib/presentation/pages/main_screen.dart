/**
 * @file main_screen.dart
 * @description 應用程式主容器 / Main application container
 * @description_zh 包含底部導覽列與子頁面切換邏輯，並於啟動時觸發全域離線數據同步
 * @description_en Contains bottom navigation bar, sub-page switching logic, and triggers global offline sync at startup
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/nav_provider.dart';
import 'home/home_page.dart';
import 'toolbox/toolbox_page.dart';
import '../../data/services/sync_service.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  @override
  void initState() {
    super.initState();
    // 進入主畫面後立即在背景啟動完整數據與圖檔同步
    // Ensure that the user doesn't have to click into pages to load data
    Future.microtask(() {
      ref.read(syncServiceProvider).fullSync();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(navigationIndexProvider);

    // 定義頁面清單 / Define page list
    final List<Widget> pages = [
      const HomePage(),
      const ToolboxPage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (index) {
            ref.read(navigationIndexProvider.notifier).state = index;
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(LucideIcons.briefcase),
              selectedIcon: Icon(LucideIcons.briefcase, color: Colors.white),
              label: '行程',
            ),
            NavigationDestination(
              icon: Icon(LucideIcons.layoutGrid),
              selectedIcon: Icon(LucideIcons.layoutGrid, color: Colors.white),
              label: '工具',
            ),
          ],
        ),
      ),
    );
  }
}
