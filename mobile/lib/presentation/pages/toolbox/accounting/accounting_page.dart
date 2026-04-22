/**
 * @file accounting_page.dart
 * @description 旅行記帳主頁面 / Travel Accounting main page
 * @description_zh 顯示支出總覽、分類統計圖表與詳細支出清單
 * @description_en Displays expense overview, category statistics chart, and detailed expense list
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../providers/accounting_provider.dart';
import '../../../../data/models/expense_entry.dart';
import '../add_expense_dialog.dart';

class AccountingPage extends ConsumerWidget {
  const AccountingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(accountingProvider);
    final total = ref.watch(accountingProvider.notifier).totalExpense;
    final categoryTotals = ref.watch(accountingProvider.notifier).categoryTotals;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('旅行記帳'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.download),
            onPressed: () {
              // 匯出功能預留
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // 1. 總額展示卡片 / Total Amount Card
          SliverToBoxAdapter(
            child: _buildOverviewCard(context, total),
          ),

          // 2. 圖表分析區 / Statistics Chart
          if (expenses.isNotEmpty)
            SliverToBoxAdapter(
              child: _buildChartSection(context, categoryTotals, total),
            ),

          // 3. 支出列表標題 / List Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '支出明細',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '共 ${expenses.length} 筆',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ),
          ),

          // 4. 空狀態或清單 / Empty State or List
          if (expenses.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.receipt, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('目前還沒有記錄喔', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildExpenseItem(context, ref, expenses[index]),
                  childCount: expenses.length,
                ),
              ),
            ),
          
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddExpense(context),
        label: const Text('新增支出'),
        icon: const Icon(LucideIcons.plus),
      ),
    );
  }

  Widget _buildOverviewCard(BuildContext context, double total) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '旅程總支出 (TWD)',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            '${NumberFormat('#,###').format(total)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryItem('今日支出', '0', LucideIcons.calendar),
              _buildSummaryItem('平均日支出', '0', LucideIcons.trendingUp),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.white60, size: 16),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11)),
            Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
      ],
    );
  }

  Widget _buildChartSection(BuildContext context, Map<ExpenseCategory, double> categoryTotals, double total) {
    if (total == 0) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '分類分析',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 4,
                      centerSpaceRadius: 40,
                      sections: categoryTotals.entries.map((e) {
                        return PieChartSectionData(
                          color: e.key.color,
                          value: e.value,
                          title: '',
                          radius: 50,
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: categoryTotals.entries.map((e) {
                      final percentage = (e.value / total * 100).toStringAsFixed(1);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(color: e.key.color, shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(e.key.label, style: const TextStyle(fontSize: 12))),
                            Text('$percentage%', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseItem(BuildContext context, WidgetRef ref, ExpenseEntry entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: entry.category.color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(entry.category.icon, color: entry.category.color),
        ),
        title: Text(entry.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DateFormat('MM/dd HH:mm').format(entry.dateTime), style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            if (entry.note != null && entry.note!.isNotEmpty)
              Text(entry.note!, style: TextStyle(fontSize: 12, color: Colors.grey[400]), maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${entry.currency} ${NumberFormat('#,###.##').format(entry.amount)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
            ),
            if (entry.currency != 'TWD')
              Text(
                '≈ TWD ${NumberFormat('#,###').format(entry.amountInBaseCurrency)}',
                style: TextStyle(fontSize: 11, color: Colors.grey[500]),
              ),
          ],
        ),
        onLongPress: () {
          // 長按刪除提示
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('刪除紀錄'),
              content: const Text('確定要刪除這筆支出嗎？'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
                TextButton(
                  onPressed: () {
                    ref.read(accountingProvider.notifier).removeEntry(entry.id);
                    Navigator.pop(context);
                  },
                  child: const Text('刪除', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAddExpense(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddExpenseDialog(),
    );
  }
}
