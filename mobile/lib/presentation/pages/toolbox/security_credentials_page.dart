/**
 * @file security_credentials_page.dart
 * @description 安全憑證頁面 / Security Credentials Page
 * @description_zh 提供旅遊證件、機票等敏感文件的加密備份與管理功能
 * @description_en Provides encrypted backup and management for sensitive travel documents like passports and tickets
 */

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/colors.dart';

class SecurityCredentialsPage extends StatelessWidget {
  const SecurityCredentialsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('安全憑證'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSecurityBanner(),
            const SizedBox(height: 24),
            _buildSectionHeader('證件分類'),
            const SizedBox(height: 12),
            _buildCategoryGrid(),
            const SizedBox(height: 32),
            _buildSectionHeader('重要文件'),
            const SizedBox(height: 12),
            _buildDocumentList(),
            const SizedBox(height: 100), // Bottom padding
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(LucideIcons.scanLine),
        label: const Text('掃描新文件'),
      ),
    );
  }

  /// 頂部安全資訊橫幅 / Top security info banner
  Widget _buildSecurityBanner() {
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
      child: const Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white24,
              shape: BoxShape.circle,
            ),
            child: Icon(LucideIcons.shieldCheck, color: Colors.white, size: 28),
          ),
          SizedBox(width: 16),
          Expanded(
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
                  '所有憑證僅儲存於此裝置，確保您的數據隱私。',
                  style: TextStyle(
                    color: Colors.whiteb70,
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

  /// 區塊標題 / Section Header
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
            onPressed: () {},
            child: const Text('全部'),
          ),
        ],
      ),
    );
  }

  /// 分類網格 / Category Grid
  Widget _buildCategoryGrid() {
    final categories = [
      {'title': '護照', 'icon': LucideIcons.contact, 'color': Colors.blue},
      {'title': '機票', 'icon': LucideIcons.plane, 'color': Colors.indigo},
      {'title': '保險', 'icon': LucideIcons.filePlus, 'color': Colors.teal},
      {'title': '簽證', 'icon': LucideIcons.stamp, 'color': Colors.amber},
    ];

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.6,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final item = categories[index];
        return Container(
          decoration: BoxDecoration(
            color: (item['color'] as Color).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: (item['color'] as Color).withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item['icon'] as IconData, color: item['color'] as Color),
                const SizedBox(height: 8),
                Text(
                  item['title'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 文件列表 / Document List
  Widget _buildDocumentList() {
    final documents = [
      {
        'title': '我的護照',
        'subtitle': '效期至 2028/10/12',
        'type': '護照',
        'icon': LucideIcons.contact,
        'status': '有效',
      },
      {
        'title': '國泰航空 - 晚班機',
        'subtitle': '航班號 CX451',
        'type': '機票',
        'icon': LucideIcons.plane,
        'status': '即將到來',
      },
    ];

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: documents.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final doc = documents[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
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
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doc['subtitle'] as String,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  doc['status'] as String,
                  style: const TextStyle(
                    color: AppColors.success,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
