/**
 * @file home_page.dart
 * @description 行程列表首頁 / Trip list home page
 * @description_zh 顯示行程概覽與建立行程入口
 * @description_en Displays trip overview and entry point for creating trips
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../widgets/create_trip_modal.dart';
import '../../../domain/entities/trip_entity.dart';
import '../../providers/auth_provider.dart';
import 'provider/home_provider.dart';
import 'pages/trip_detail_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsAsync = ref.watch(tripsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的行程'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.arrowLeft),
            tooltip: '返回選擇使用者',
            onPressed: () {
              ref.read(authProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: tripsAsync.when(
        data: (trips) => trips.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.map, size: 64, color: Colors.grey.shade300),
                    const SizedBox(height: 16),
                    Text('目前沒有行程', style: TextStyle(color: Colors.grey.shade500)),
                  ],
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: trips.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final trip = trips[index];
                  return _buildTripCard(
                    context,
                    trip: trip,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TripDetailPage(trip: trip),
                      ),
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(LucideIcons.alertCircle, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text('加載失敗: $err'),
              TextButton(
                onPressed: () => ref.refresh(tripsProvider),
                child: const Text('重試'),
              ),
            ],
          ),
        ),
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
    required TripEntity trip,
    required VoidCallback onTap,
  }) {
    final iconData = _getIconData(trip.iconName);
    // 安全處理顏色數值 / Guarded color parsing
    final primaryColor = trip.colorValue != null ? Color(trip.colorValue!) : Theme.of(context).primaryColor;
    final backgroundColor = primaryColor.withOpacity(0.1);
    
    final dateRange = '${DateFormat('yyyy/MM/dd').format(trip.startDate)} - ${DateFormat('MM/dd').format(trip.endDate)}';

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 縮圖區域 / Thumbnail area
              Container(
                width: 100,
                color: backgroundColor,
                child: Center(
                  child: Icon(iconData, color: primaryColor, size: 32),
                ),
              ),
              // 內容區域 / Content area
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trip.title,
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
                              dateRange,
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
                              trip.location ?? '未知地點',
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
                            '${trip.memberCount} 位成員',
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
              // 右側箭頭 / Right arrow
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(LucideIcons.chevronRight, color: Colors.grey.shade400),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String? name) {
    switch (name) {
      case 'palmtree':
        return LucideIcons.palmtree;
      case 'flower2':
        return LucideIcons.flower2;
      case 'mountain':
        return LucideIcons.mountain;
      case 'plane':
        // 針對不同版本 LucideIcons 做相容處理 / Fallback for different icon versions
        return LucideIcons.plane;
      default:
        return LucideIcons.map;
    }
  }
}
