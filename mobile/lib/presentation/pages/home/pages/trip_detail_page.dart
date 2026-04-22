/**
 * @file trip_detail_page.dart
 * @description 行程詳情詳情頁面 / Trip Detail page
 * @description_zh 顯示每日時間軸與活動內容
 * @description_en Displays daily timeline and activity content
 */

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'activity_detail_page.dart';

class TripDetailPage extends StatelessWidget {
  final String title;

  const TripDetailPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          _buildDaySelector(),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 16),
              _buildTimelineActivity(
                context,
                time: '06:00',
                title: '洛杉磯國際機場 (LAX)',
                subtitle: '抵達大廳，準備取車',
                icon: LucideIcons.planeLanding,
                isFirst: true,
                personalInfo: {
                  '航班編號': 'BR12',
                  '航空公司': '長榮航空',
                  '航廈': 'Tom Bradley (TBIT)',
                  '抵達時間': '06:00 AM',
                },
              ),
              _buildTimelineActivity(
                context,
                time: '08:00',
                title: '現存最古老的麥當勞',
                subtitle: '位於 Downey 的經典旗艦店',
                icon: LucideIcons.utensils,
              ),
              _buildTimelineActivity(
                context,
                time: '10:30',
                title: '格里菲斯天文台',
                subtitle: '俯瞰洛杉磯全景',
                icon: LucideIcons.mountain,
              ),
              _buildTimelineActivity(
                context,
                time: '13:00',
                title: 'In-N-Out Burger',
                subtitle: '西岸必吃漢堡',
                icon: LucideIcons.beef,
                isLast: true,
              ),
            ]),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(LucideIcons.plus),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withValues(alpha: 0.8),
                  ],
                ),
              ),
              child: const Icon(LucideIcons.palmtree, size: 80, color: Colors.white24),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black45],
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

  Widget _buildDaySelector() {
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
            _buildDayItem('4/25', '六', false),
            _buildDayItem('4/26', '日', true),
            _buildDayItem('4/27', '一', false),
            _buildDayItem('4/28', '二', false),
            _buildDayItem('4/29', '三', false),
          ],
        ),
      ),
    );
  }

  Widget _buildDayItem(String date, String day, bool isSelected) {
    return Container(
      width: 70,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF0D9488) : Colors.grey.shade100,
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
    required String time,
    required String title,
    required String subtitle,
    required IconData icon,
    bool isFirst = false,
    bool isLast = false,
    Map<String, String>? personalInfo,
  }) {
    return IntrinsicHeight(
      child: Row(
        children: [
          // Timeline 軸線部分 / Timeline axis section
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
                  color: personalInfo != null ? const Color(0xFF0D9488) : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: personalInfo != null ? const Color(0xFF0D9488) : Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: personalInfo != null ? Colors.white : Colors.grey.shade600,
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
          // 內容部分 / Content section
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ActivityDetailPage(
                      title: title,
                      category: '旅遊活動',
                      personalInfo: personalInfo,
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
                      time,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D9488),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                    if (personalInfo != null)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D9488).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          '包含預訂資訊',
                          style: TextStyle(
                            color: Color(0xFF0D9488),
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
}
