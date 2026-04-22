/**
 * @file activity_detail_page.dart
 * @description 活動/景點詳情頁面 / Activity or Attraction Detail page
 * @description_zh 顯示景點詳細介紹、圖片與周邊資訊
 * @description_en Displays detailed attraction info, images, and nearby info
 */

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ActivityDetailPage extends StatelessWidget {
  final String title;
  final String category;
  final Map<String, String>? personalInfo;

  const ActivityDetailPage({
    super.key,
    required this.title,
    required this.category,
    this.personalInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (personalInfo != null) _buildPersonalInfoCard(context),
                  const SizedBox(height: 24),
                  _buildSectionTitle('詳細介紹'),
                  const SizedBox(height: 12),
                  const Text(
                    '這裡是洛杉磯最具代表性的地點之一。無論是歷史悠久的建築風格，還是其在全球文化中的獨特性，都吸引了無數遊客。在這裡你可以感受到時光的流轉與現代商業的融合。',
                    style: TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle('周邊景點與美食'),
                  const SizedBox(height: 16),
                  _buildNearbyList(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // 模擬圖片 / Mock Image
            Container(
              color: Colors.grey.shade200,
              child: Center(
                child: Icon(LucideIcons.camera, size: 64, color: Colors.grey.shade400),
              ),
            ),
            // 漸層遮罩 / Gradient overlay
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black26, Colors.transparent, Colors.black54],
                ),
              ),
            ),
          ],
        ),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildPersonalInfoCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.user, size: 18, color: Theme.of(context).primaryColor),
              const SizedBox(width: 8),
              const Text('我的預訂資訊', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 12),
          ...personalInfo!.entries.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(e.key, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                Text(e.value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildNearbyList() {
    return SizedBox(
      height: 180,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildNearbyCard('Porto\'s Bakery', '附近美食', LucideIcons.cakeSlice),
          _buildNearbyCard('Columbia Memorial', '相關景點', LucideIcons.landmark),
          _buildNearbyCard('In-N-Out Burger', '附近美食', LucideIcons.beef),
        ],
      ),
    );
  }

  Widget _buildNearbyCard(String title, String subtitle, IconData icon) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Center(child: Icon(icon, color: Colors.grey.shade400)),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), overflow: TextOverflow.ellipsis),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
