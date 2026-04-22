/**
 * @file packing_list_page.dart
 * @description 行李打包清單頁面 / Packing list page
 * @description_zh 提供結構化的行李清單，支援核取、分類檢視與自定義新增功能
 * @description_en Provides a structured packing list with checkable items, categorized views, and custom item addition
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../providers/packing_list_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final packingItems = ref.watch(packingListProvider);
    
    // 按類別分組 / Group by category
    final Map<String, List<PackingItem>> groupedItems = {};
    for (var item in packingItems) {
      groupedItems.putIfAbsent(item.category, () => []).add(item);
    }

    final categories = groupedItems.keys.toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          for (var category in categories) ...[
            _buildCategorySection(category, groupedItems[category]!),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddItemDialog(context),
        icon: const Icon(LucideIcons.plus),
        label: const Text('新增項目'),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: false,
      pinned: true,
      centerTitle: true,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          '打包清單',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
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

  Widget _buildCategorySection(String category, List<PackingItem> items) {
    // 計算已選取比例 / Calculate progress
    final checkedCount = items.where((i) => i.isChecked).length;
    final progress = items.isEmpty ? 0 : checkedCount / items.length;

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
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  '$checkedCount / ${items.length}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress.toDouble(),
                backgroundColor: AppColors.border,
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress == 1.0 ? AppColors.success : AppColors.primary,
                ),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 12),
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
                  height: 1,
                  indent: 50,
                  endIndent: 20,
                  color: AppColors.divider,
                ),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    leading: Checkbox(
                      value: item.isChecked,
                      onChanged: (_) => ref.read(packingListProvider.notifier).toggleItem(item.id),
                      activeColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    title: Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 15,
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

  void _showAddItemDialog(BuildContext context) {
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
            left: 20,
            right: 20,
            top: 20,
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
                children: [
                  '重要證件與金流',
                  '電子產品與配件',
                  '個人衣物與穿戴',
                  '盥洗物品',
                  '其他',
                ].map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setModalState(() => _selectedCategory = cat);
                      }
                    },
                    selectedColor: AppColors.primary.withValues(alpha: 0.1),
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  if (_customItemController.text.isNotEmpty) {
                    ref.read(packingListProvider.notifier).addItem(
                      _customItemController.text,
                      _selectedCategory,
                    );
                    _customItemController.clear();
                    Navigator.pop(context);
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
