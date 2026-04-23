/**
 * @file security_credentials_page.dart
 * @description 安全憑證頁面 / Security Credentials Page
 * @description_zh 提供旅遊證件、機票等敏感文件的加密備份與管理功能，採 Sliver 高性能佈局
 * @description_en Provides encrypted backup for sensitive travel documents using high-performance Sliver layout
 */

library;

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/colors.dart';

class SecurityCredentialsPage extends StatelessWidget {
  const SecurityCredentialsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // 自定義 AppBar / Custom AppBar
          SliverAppBar(
            title: const Text('安全憑證'),
            floating: true,
            pinned: true,
            backgroundColor: AppColors.background,
            actions: [
              IconButton(
                icon: const Icon(LucideIcons.settings),
                onPressed: () => _showToast(context, '設定開發中'),
              ),
            ],
          ),

          // 頂部安全資訊 / Top Security Banner
          SliverToBoxAdapter(
            child: _buildSecurityBanner(context),
          ),

          // 證件分類標題 / Category Header
          SliverToBoxAdapter(
            child: _buildSectionHeader(context, '證件分類'),
          ),

          // 分類網格 / Category Grid (Sliver)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            sliver: _buildCategorySliverGrid(context),
          ),

          // 重要文件標題 / Document Header
          SliverToBoxAdapter(
            child: _buildSectionHeader(context, '重要文件'),
          ),

          // 文件列表 / Document List (Sliver)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
            sliver: _buildDocumentSliverList(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showToast(context, '掃描功能開發中'),
        icon: const Icon(LucideIcons.scanLine),
        label: const Text('掃描新文件'),
      ),
    );
  }

  void _showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Widget _buildSecurityBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.white24,
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.shieldCheck, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '文件已受進階加密保護',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '所有憑證僅儲存於此裝置，確保數據隱私。',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          TextButton(
            onPressed: () => _showToast(context, '查看全部功能開發中'),
            child: const Text('全部'),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySliverGrid(BuildContext context) {
    final categories = [
      {'title': '護照', 'icon': LucideIcons.contact, 'color': Colors.blue},
      {'title': '機票', 'icon': LucideIcons.plane, 'color': Colors.indigo},
      {'title': '保險', 'icon': LucideIcons.filePlus, 'color': Colors.teal},
      {'title': '簽證', 'icon': LucideIcons.stamp, 'color': Colors.amber},
    ];

    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.6,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final item = categories[index];
          final color = item['color'] as Color;
          return Container(
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withValues(alpha: 0.2)),
            ),
            child: InkWell(
              onTap: () => _showToast(context, '正在開啟${item['title']}分類'),
              borderRadius: BorderRadius.circular(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item['icon'] as IconData, color: color),
                  const SizedBox(height: 8),
                  Text(
                    item['title'] as String,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ],
              ),
            ),
          );
        },
        childCount: categories.length,
      ),
    );
  }

  Widget _buildDocumentSliverList(BuildContext context) {
    final documents = [
      {
        'title': '我的護照',
        'subtitle': '效期至 2028/10/12',
        'icon': LucideIcons.contact,
        'status': '有效',
        'statusColor': AppColors.success,
      },
      {
        'title': '國泰航空 - 晚班機',
        'subtitle': '航班號 CX451',
        'icon': LucideIcons.plane,
        'status': '即將到來',
        'statusColor': AppColors.info,
      },
    ];

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final doc = documents[index];
          final sColor = doc['statusColor'] as Color;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: InkWell(
                onTap: () => _showToast(context, '正在讀取文件: ${doc['title']}'),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(doc['icon'] as IconData, color: AppColors.primary),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doc['title'] as String,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            doc['subtitle'] as String,
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: sColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        doc['status'] as String,
                        style: TextStyle(color: sColor, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        childCount: documents.length,
      ),
    );
  }
}
