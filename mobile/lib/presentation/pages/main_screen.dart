/**
 * @file main_screen.dart
 * @description 應用程式主容器 / Main application container
 * @description_zh 包含底部導覽列與子頁面切換邏輯
 * @description_en Contains bottom navigation bar and sub-page switching logic
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/nav_provider.dart';
import 'home/home_page.dart';
import 'explore/explore_page.dart';
import 'toolbox/toolbox_page.dart';
import 'profile/profile_page.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);

    // 定義頁面清單 / Define page list
    final List<Widget> pages = [
      const HomePage(),
      const ExplorePage(),
      const ToolboxPage(),
      const ProfilePage(),
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
              icon: Icon(LucideIcons.compass),
              selectedIcon: Icon(LucideIcons.compass, color: Colors.white),
              label: '探索',
            ),
            NavigationDestination(
              icon: Icon(LucideIcons.layoutGrid),
              selectedIcon: Icon(LucideIcons.layoutGrid, color: Colors.white),
              label: '工具',
            ),
            NavigationDestination(
              icon: Icon(LucideIcons.user),
              selectedIcon: Icon(LucideIcons.user, color: Colors.white),
              label: '設定',
            ),
          ],
        ),
      ),
    );
  }
}
