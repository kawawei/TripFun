/**
 * @file accounting_provider.dart
 * @description 記帳狀態管理 / Accounting state management
 * @description_zh 管理支出清單數據，包含新增、刪除與統計邏輯
 * @description_en Manages expense list data, including add, delete, and statistics logic
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/expense_entry.dart';
import 'package:uuid/uuid.dart';

final accountingProvider = StateNotifierProvider<AccountingNotifier, List<ExpenseEntry>>((ref) {
  return AccountingNotifier();
});

class AccountingNotifier extends StateNotifier<List<ExpenseEntry>> {
  AccountingNotifier() : super([]) {
    // 這裡可以從 SharedPreferences 載入初始數據
  }

  final _uuid = const Uuid();

  // 新增支出
  void addEntry({
    required double amount,
    required String currency,
    required double amountInBaseCurrency,
    required ExpenseCategory category,
    required String title,
    String? note,
    required DateTime dateTime,
  }) {
    final entry = ExpenseEntry(
      id: _uuid.v4(),
      amount: amount,
      currency: currency,
      amountInBaseCurrency: amountInBaseCurrency,
      category: category,
      title: title,
      note: note,
      dateTime: dateTime,
    );
    state = [entry, ...state];
  }

  // 刪除支出
  void removeEntry(String id) {
    state = state.where((entry) => entry.id != id).toList();
  }

  // 計算總支出 (以主幣別計)
  double get totalExpense => state.fold(0, (sum, entry) => sum + entry.amountInBaseCurrency);

  // 按類別統計
  Map<ExpenseCategory, double> get categoryTotals {
    final Map<ExpenseCategory, double> totals = {};
    for (var entry in state) {
      totals[entry.category] = (totals[entry.category] ?? 0) + entry.amountInBaseCurrency;
    }
    return totals;
  }
}
