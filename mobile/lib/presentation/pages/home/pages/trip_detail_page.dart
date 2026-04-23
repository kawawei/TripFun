/**
 * @file trip_detail_page.dart
 * @description 行程詳情詳情頁面 / Trip Detail page
 * @description_zh 顯示每日時間軸與活動內容
 * @description_en Displays daily timeline and activity content
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../domain/entities/trip_entity.dart';
import '../../../../domain/entities/activity_entity.dart';
import '../provider/activity_provider.dart';
import 'activity_detail_page.dart';

class TripDetailPage extends ConsumerWidget {
  final TripEntity trip;

  const TripDetailPage({super.key, required this.trip});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activitiesAsync = ref.watch(activitiesProvider(trip.id));
    final primaryColor = trip.colorValue != null ? Color(trip.colorValue!) : Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context, primaryColor),
          _buildDaySelector(primaryColor),
          activitiesAsync.when(
            data: (activities) => activities.isEmpty
                ? const SliverFillRemaining(
                    child: Center(child: Text('目前沒有活動安排')),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final activity = activities[index];
                        return _buildTimelineActivity(
                          context,
                          activity: activity,
                          primaryColor: primaryColor,
                          isFirst: index == 0,
                          isLast: index == activities.length - 1,
                        );
                      },
                      childCount: activities.length,
                    ),
                  ),
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, stack) => SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.alertCircle, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text('加載活動失敗: $err'),
                    TextButton(
                      onPressed: () => ref.refresh(activitiesProvider(trip.id)),
                      child: const Text('重試'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)), // 底部留白 / Bottom padding
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: primaryColor,
        child: const Icon(LucideIcons.plus, color: Colors.white),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, Color primaryColor) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      elevation: 0,
      backgroundColor: primaryColor,
      iconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          trip.title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    primaryColor,
                    primaryColor.withOpacity(0.8),
                  ],
                ),
              ),
              child: Icon(_getIconData(trip.iconName), size: 80, color: Colors.white24),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black26],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(icon: const Icon(LucideIcons.share2), onPressed: () {}),
        IconButton(icon: const Icon(LucideIcons.moreVertical), onPressed: () {}),
      ],
    );
  }

  Widget _buildDaySelector(Color primaryColor) {
    // 這裡暫時手動生成日期範圍，實際可從 trip.startDate/endDate 計算 / Currently manual, can be calculated from startDate/endDate
    return SliverToBoxAdapter(
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
        ),
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            _buildDayItem('4/25', '六', true, primaryColor),
            _buildDayItem('4/26', '日', false, primaryColor),
            _buildDayItem('4/27', '一', false, primaryColor),
            _buildDayItem('4/28', '二', false, primaryColor),
            _buildDayItem('4/29', '三', false, primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildDayItem(String date, String day, bool isSelected, Color primaryColor) {
    return Container(
      width: 70,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: isSelected ? primaryColor : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(day, style: TextStyle(color: isSelected ? Colors.white70 : Colors.grey, fontSize: 12)),
          Text(date, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildTimelineActivity(
    BuildContext context, {
    required ActivityEntity activity,
    required Color primaryColor,
    bool isFirst = false,
    bool isLast = false,
  }) {
    final iconData = _getActivityIconData(activity.iconName, activity.type);
    final hasPersonalInfo = activity.personalInfo != null && activity.personalInfo!.isNotEmpty;

    return IntrinsicHeight(
      child: Row(
        children: [
          const SizedBox(width: 24),
          Column(
            children: [
              Container(
                width: 2,
                height: 16,
                color: isFirst ? Colors.transparent : Colors.grey.shade200,
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: hasPersonalInfo ? primaryColor : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: hasPersonalInfo ? primaryColor : Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: Icon(
                  iconData,
                  size: 20,
                  color: hasPersonalInfo ? Colors.white : Colors.grey.shade600,
                ),
              ),
              Expanded(
                child: Container(
                  width: 2,
                  color: isLast ? Colors.transparent : Colors.grey.shade200,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ActivityDetailPage(
                      title: activity.title,
                      category: activity.type,
                      personalInfo: activity.personalInfo?.map((k, v) => MapEntry(k, v.toString())),
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.time,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      activity.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      activity.subtitle ?? '',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                    if (hasPersonalInfo)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '包含預訂資訊',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  IconData _getIconData(String? name) {
    switch (name) {
      case 'palmtree': return LucideIcons.palmtree;
      case 'flower2': return LucideIcons.flower2;
      case 'mountain': return LucideIcons.mountain;
      case 'plane': return LucideIcons.plane;
      default: return LucideIcons.map;
    }
  }

  IconData _getActivityIconData(String? name, String type) {
    if (name != null) {
      switch (name) {
        case 'plane-landing': return LucideIcons.planeLanding;
        case 'utensils': return LucideIcons.utensils;
        case 'mountain': return LucideIcons.mountain;
        case 'beef': return LucideIcons.beef;
      }
    }
    
    switch (type) {
      case 'FLIGHT': return LucideIcons.plane;
      case 'HOTEL': return LucideIcons.hotel;
      case 'FOOD': return LucideIcons.utensils;
      case 'TRANSPORT': return LucideIcons.car;
      default: return LucideIcons.mapPin;
    }
  }
}
