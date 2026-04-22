/**
 * @file home_page.dart
 * @description 行程列表首頁 / Trip list home page
 * @description_zh 顯示行程概覽與建立行程入口
 * @description_en Displays trip overview and entry point for creating trips
 */

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../widgets/create_trip_modal.dart';

import 'pages/trip_detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的行程'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(LucideIcons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildTripCard(
            context,
            title: '洛杉磯公路旅行',
            dates: '2026/04/25 - 04/29',
            location: '美國, 加州',
            memberCount: 2,
            imageColor: Colors.teal.shade50,
            icon: LucideIcons.palmtree,
            iconColor: Colors.teal,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TripDetailPage(title: '洛杉磯公路旅行')),
            ),
          ),
          const SizedBox(height: 16),
          _buildTripCard(
            context,
            title: '東京櫻花季之旅',
            dates: '2026/03/25 - 03/30',
            location: '日本, 東京',
            memberCount: 4,
            imageColor: Colors.pink.shade50,
            icon: LucideIcons.flower2,
            iconColor: Colors.pink,
            onTap: () {},
          ),
          const SizedBox(height: 16),
          _buildTripCard(
            context,
            title: '瑞士阿爾卑斯山健行',
            dates: '2026/07/15 - 07/25',
            location: '瑞士, 策馬特',
            memberCount: 2,
            imageColor: Colors.blue.shade50,
            icon: LucideIcons.mountain,
            iconColor: Colors.blue,
            onTap: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => CreateTripModal.show(context),
        icon: const Icon(LucideIcons.plus),
        label: const Text('建立行程'),
      ),
    );
  }

  Widget _buildTripCard(
    BuildContext context, {
    required String title,
    required String dates,
    required String location,
    required int memberCount,
    required Color imageColor,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 縮圖區域 / Thumbnail area
            Container(
              width: 100,
              constraints: const BoxConstraints(minHeight: 120),
              color: imageColor,
              child: Center(
                child: Icon(icon, color: iconColor, size: 32),
              ),
            ),
            // 內容區域 / Content area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(LucideIcons.calendar, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            dates,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey.shade600,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(LucideIcons.mapPin, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey.shade600,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(LucideIcons.users, size: 14, color: Theme.of(context).primaryColor),
                        const SizedBox(width: 4),
                        Text(
                          '$memberCount 位成員',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(LucideIcons.chevronRight, color: Colors.grey.shade400),
            ),
          ],
        ),
      ),
    );
  }
}
