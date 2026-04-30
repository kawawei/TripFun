/**
 * @file accounting_provider.dart
 * @description 記帳狀態管理 / Accounting state management
 * @description_zh 管理支出清單數據，包含新增、刪除與統計邏輯，支援 Drift (SQLite) 本地持久化與雲端同步
 * @description_en Manages expense list data, including add, delete, and statistics logic, supporting Drift (SQLite) local persistence and cloud sync
 */

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../../data/models/expense_entry.dart';
import '../../data/local/app_database.dart';
import '../../core/providers/database_provider.dart';
import '../../data/repositories/expense_repository_impl.dart';
import 'package:uuid/uuid.dart';

final accountingProvider = StateNotifierProvider<AccountingNotifier, List<ExpenseEntry>>((ref) {
  return AccountingNotifier(ref);
});

class AccountingNotifier extends StateNotifier<List<ExpenseEntry>> {
  final Ref _ref;
  AccountingNotifier(this._ref) : super([]) {
    _loadFromLocal();
  }

  final _uuid = const Uuid();

  // 1. 從本地資料庫載入
  Future<void> _loadFromLocal() async {
    if (kIsWeb) return;
    final db = _ref.read(databaseProvider);
    
    final query = db.select(db.expenses)
      ..where((t) => t.isDeleted.equals(false))
      ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]);
    
    final rows = await query.get();

    state = rows.map((c) => ExpenseEntry(
      id: c.remoteId ?? c.id.toString(),
      amount: c.amount,
      currency: c.currency,
      amountInBaseCurrency: c.amountInBaseCurrency,
      category: ExpenseCategory.values.firstWhere((e) => e.name == c.category),
      title: c.title,
      note: c.note,
      dateTime: c.date,
    )).toList();
    
    // 載入本地後嘗試與雲端同步
    syncWithCloud();
  }

  // 2. 新增支出
  Future<void> addEntry({
    required double amount,
    required String currency,
    required double amountInBaseCurrency,
    required ExpenseCategory category,
    required String title,
    String? note,
    required DateTime dateTime,
    String? tripId,
  }) async {
    final newId = _uuid.v4();
    final entry = ExpenseEntry(
      id: newId,
      amount: amount,
      currency: currency,
      amountInBaseCurrency: amountInBaseCurrency,
      category: category,
      title: title,
      note: note,
      dateTime: dateTime,
    );

    // 更新 UI 狀態 (樂觀更新)
    state = [entry, ...state];

    // 寫入本地資料庫
    if (kIsWeb) {
      _syncSingleEntry(entry, tripId ?? 'default');
      return;
    }
    
    final db = _ref.read(databaseProvider);
    await db.into(db.expenses).insert(
      ExpensesCompanion.insert(
        remoteId: Value(newId),
        tripId: tripId ?? 'default',
        amount: amount,
        currency: currency,
        amountInBaseCurrency: amountInBaseCurrency,
        category: category.name,
        title: title,
        note: Value(note),
        date: dateTime,
        isSynced: const Value(false),
      ),
    );

    // 嘗試同步
    syncWithCloud(tripId: tripId);
  }

  // 3. 刪除支出
  Future<void> removeEntry(String id) async {
    // 預先過濾 UI
    state = state.where((entry) => entry.id != id).toList();

    if (kIsWeb) {
      try {
        await _ref.read(expenseRepositoryProvider).deleteExpense(id);
      } catch (_) {}
      return;
    }

    final db = _ref.read(databaseProvider);
    // 直接刪除本地 (簡單處理)
    final deleteQuery = db.delete(db.expenses)..where((t) => t.remoteId.equals(id));
    await deleteQuery.go();

    try {
      await _ref.read(expenseRepositoryProvider).deleteExpense(id);
    } catch (_) {
      // 網路失敗暫不處理，可透過後續的全同步機制修正
    }
  }

  // 4. 與雲端同步
  Future<void> syncWithCloud({String? tripId}) async {
    if (kIsWeb) return;
    
    final currentTripId = tripId ?? '44444444-4444-4444-4444-444444444444';
    final db = _ref.read(databaseProvider);

    try {
      // A. 獲取本地未同步的數據
      final unsyncedQuery = db.select(db.expenses)
        ..where((t) => t.isSynced.equals(false) & t.isDeleted.equals(false));
      final unsynced = await unsyncedQuery.get();

      if (unsynced.isNotEmpty) {
        final entriesToSync = unsynced.map((c) => ExpenseEntry(
          id: c.remoteId!,
          amount: c.amount,
          currency: c.currency,
          amountInBaseCurrency: c.amountInBaseCurrency,
          category: ExpenseCategory.values.firstWhere((e) => e.name == c.category),
          title: c.title,
          note: c.note,
          dateTime: c.date,
        )).toList();

        await _ref.read(expenseRepositoryProvider).syncExpenses(currentTripId, entriesToSync);

        // 更新本地狀態為已同步
        for (var item in unsynced) {
          final updateQuery = db.update(db.expenses)..where((t) => t.id.equals(item.id));
          await updateQuery.write(const ExpensesCompanion(isSynced: Value(true)));
        }
      }
    } catch (e) {
      print('Sync failed: $e');
    }
  }

  // 單筆同步
  Future<void> _syncSingleEntry(ExpenseEntry entry, String tripId) async {
    try {
      await _ref.read(expenseRepositoryProvider).syncExpenses(tripId, [entry]);
    } catch (_) {}
  }

  double get totalExpense => state.fold(0, (sum, entry) => sum + entry.amountInBaseCurrency);

  Map<ExpenseCategory, double> get categoryTotals {
    final Map<ExpenseCategory, double> totals = {};
    for (var entry in state) {
      totals[entry.category] = (totals[entry.category] ?? 0) + entry.amountInBaseCurrency;
    }
    return totals;
  }
}
