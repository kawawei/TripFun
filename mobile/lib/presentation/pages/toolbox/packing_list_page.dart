/**
 * @file packing_list_page.dart
 * @description 行李打包清單頁面 / Packing list page
 * @description_zh 提供結構化的行李清單，串接後端 API，支援個人化勾選狀態、分類檢視與自定義新增功能
 * @description_en Provides a structured packing list connected to backend API, with personalized check state, categorized views, and custom item addition
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../providers/packing_list_provider.dart';
import '../../providers/auth_provider.dart';
import '../../../data/models/packing_item.dart';
import '../../../core/constants/colors.dart';

class PackingListPage extends ConsumerStatefulWidget {
  const PackingListPage({super.key});

  @override
  ConsumerState<PackingListPage> createState() => _PackingListPageState();
}

class _PackingListPageState extends ConsumerState<PackingListPage> {
  final TextEditingController _customItemController = TextEditingController();
  String _selectedCategory = '重要證件與金流';

  @override
  void dispose() {
    _customItemController.dispose();
    super.dispose();
  }


  // ========================================
  // 下拉刷新 / Pull to refresh
  // ========================================
  Future<void> _onRefresh() async {
    await ref.read(packingListProvider.notifier).fetchPackingList();
  }

  @override
  Widget build(BuildContext context) {
    final packingState = ref.watch(packingListProvider);
    final packingItems = packingState.items;
    final isLoading = packingState.isLoading;
    final user = ref.watch(authProvider);

    // ========================================
    // 按類別分組 / Group by category
    // ========================================
    final Map<String, List<PackingItem>> groupedItems = {};
    for (var item in packingItems) {
      groupedItems.putIfAbsent(item.category, () => []).add(item);
    }
    final categories = groupedItems.keys.toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppColors.primary,
        child: CustomScrollView(
          slivers: [
            _buildAppBar(packingItems),
            // ========================================
            // 未登入提示 / Not logged in notice
            // ========================================
            if (user == null)
              const SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.userX, size: 48, color: AppColors.textSecondary),
                      SizedBox(height: 12),
                      Text('請先選擇旅客身份', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                    ],
                  ),
                ),
              )
            // ========================================
            // 載入中 / Loading
            // ========================================
            if (isLoading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            // ========================================
            // 空清單提示 / Empty state
            // ========================================
            else if (packingItems.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.packageOpen, size: 56, color: AppColors.textSecondary.withValues(alpha: 0.4)),
                      const SizedBox(height: 16),
                      const Text('清單是空的', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                      const SizedBox(height: 8),
                      const Text('點擊右下角按鈕新增行李項目', style: TextStyle(color: AppColors.textPlaceholder)),
                    ],
                  ),
                ),
              )
            else ...[
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              // ========================================
              // 整體進度摘要 / Overall progress summary
              // ========================================
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildOverallProgress(packingItems),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
              // ========================================
              // 分類清單 / Category sections
              // ========================================
              for (var category in categories) ...[
                _buildCategorySection(category, groupedItems[category]!),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ],
        ),
      ),
      floatingActionButton: user != null && packingItems.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => _showAddItemDialog(context),
              icon: const Icon(LucideIcons.plus),
              label: const Text('新增項目'),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            )
          : null,
    );
  }

  // ========================================
  // AppBar 建構 / AppBar builder
  // ========================================
  Widget _buildAppBar(List<PackingItem> items) {
    final checkedCount = items.where((i) => i.isChecked).length;
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: false,
      pinned: true,
      centerTitle: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          items.isEmpty ? '打包清單' : '打包清單 ($checkedCount/${items.length})',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontSize: 16,
          ),
        ),
        background: Container(
          color: AppColors.background,
          child: Opacity(
            opacity: 0.05,
            child: Icon(LucideIcons.luggage, size: 100, color: AppColors.primary),
          ),
        ),
      ),
    );
  }

  // ========================================
  // 整體進度摘要卡片 / Overall progress card
  // ========================================
  Widget _buildOverallProgress(List<PackingItem> items) {
    final checkedCount = items.where((i) => i.isChecked).length;
    final total = items.length;
    final progress = total == 0 ? 0.0 : checkedCount / total;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: progress == 1.0
              ? [const Color(0xFF10b981), const Color(0xFF059669)]
              : [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(
            progress == 1.0 ? LucideIcons.checkCircle2 : LucideIcons.luggage,
            color: Colors.white,
            size: 36,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  progress == 1.0 ? '行李準備完畢！' : '行李準備進度',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$checkedCount / $total 項已核取',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ========================================
  // 分類區塊建構 / Category section builder
  // ========================================
  Widget _buildCategorySection(String category, List<PackingItem> items) {
    final checkedCount = items.where((i) => i.isChecked).length;
    final progress = items.isEmpty ? 0.0 : checkedCount / items.length;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  '$checkedCount / ${items.length}',
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.border,
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress == 1.0 ? AppColors.success : AppColors.primary,
                ),
                minHeight: 5,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 1, indent: 50, endIndent: 20, color: AppColors.divider,
                ),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    leading: Checkbox(
                      value: item.isChecked,
                      onChanged: (_) => ref.read(packingListProvider.notifier).toggleItem(item.id),
                      activeColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    title: Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 14,
                        color: item.isChecked ? AppColors.textSecondary : AppColors.textPrimary,
                        decoration: item.isChecked ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    trailing: item.isCustom
                        ? IconButton(
                            icon: const Icon(LucideIcons.x, size: 18, color: AppColors.textPlaceholder),
                            onPressed: () => ref.read(packingListProvider.notifier).removeItem(item.id),
                          )
                        : null,
                    onTap: () => ref.read(packingListProvider.notifier).toggleItem(item.id),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========================================
  // 新增項目 Dialog / Add item dialog
  // ========================================
  void _showAddItemDialog(BuildContext context) {
    // 從現有清單取得所有已存在的類別
    final existingCategories = ref
        .read(packingListProvider)
        .map((item) => item.category)
        .toSet()
        .toList();

    if (!existingCategories.contains(_selectedCategory)) {
      _selectedCategory = existingCategories.isNotEmpty ? existingCategories.first : '其他';
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20, right: 20, top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                '新增行李項目',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _customItemController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: '請輸入項目名稱 (如：備用電池)',
                  prefixIcon: Icon(LucideIcons.listPlus),
                ),
              ),
              const SizedBox(height: 16),
              const Text('選擇分類', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: existingCategories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return ChoiceChip(
                    label: Text(cat, style: const TextStyle(fontSize: 12)),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) setModalState(() => _selectedCategory = cat);
                    },
                    selectedColor: AppColors.primary.withValues(alpha: 0.1),
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                onPressed: () async {
                  if (_customItemController.text.isNotEmpty) {
                    await ref.read(packingListProvider.notifier).addItem(
                      _customItemController.text,
                      _selectedCategory,
                    );
                    _customItemController.clear();
                    if (context.mounted) Navigator.pop(context);
                  }
                },
                child: const Text('確認新增'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
