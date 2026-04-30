/**
 * @file accounting_provider.dart
 * @description 記帳狀態管理 / Accounting state management
 * @description_zh 管理支出清單數據，包含新增、刪除與統計邏輯，支援 Isar 本地持久化
 * @description_en Manages expense list data, including add, delete, and statistics logic, supporting Isar local persistence
 */

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../data/models/expense_entry.dart';
import '../../data/local/isar_service.dart';
import '../../data/local/collections/expense_collection.dart';
import 'package:uuid/uuid.dart';

final accountingProvider = StateNotifierProvider<AccountingNotifier, List<ExpenseEntry>>((ref) {
  return AccountingNotifier();
});

class AccountingNotifier extends StateNotifier<List<ExpenseEntry>> {
  AccountingNotifier() : super([]) {
    _loadFromLocal();
  }

  final _uuid = const Uuid();

  // 1. 從本地資料庫載入
  Future<void> _loadFromLocal() async {
    if (kIsWeb) return;
    final isar = await IsarService.instance;
    if (isar == null) return;
    final collections = await isar.expenseCollections
        .where()
        .filter()
        .isDeletedEqualTo(false)
        .sortByDateTimeDesc()
        .findAll();

    state = collections.map((c) => ExpenseEntry(
      id: c.remoteId ?? c.id.toString(),
      amount: c.amount,
      currency: c.currency,
      amountInBaseCurrency: c.amountInBaseCurrency,
      category: ExpenseCategory.values.firstWhere((e) => e.name == c.category),
      title: c.title,
      note: c.note,
      dateTime: c.dateTime,
    )).toList();
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
    String? tripId, // 建議傳入目前行程 ID
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
    if (kIsWeb) return;
    final isar = await IsarService.instance;
    if (isar == null) return;
    await isar.writeTxn(() async {
      final collection = ExpenseCollection()
        ..remoteId = newId
        ..tripId = tripId ?? 'default' // 若無行程 ID 則標記為默認
        ..amount = amount
        ..currency = currency
        ..amountInBaseCurrency = amountInBaseCurrency
        ..category = category.name
        ..title = title
        ..note = note
        ..dateTime = dateTime
        ..isSynced = false;
      
      await isar.expenseCollections.putByRemoteId(collection);
    });
  }

  // 3. 刪除支出
  Future<void> removeEntry(String id) async {
    // 預先過濾 UI
    state = state.where((entry) => entry.id != id).toList();

    if (kIsWeb) return;
    final isar = await IsarService.instance;
    if (isar == null) return;
    await isar.writeTxn(() async {
      // 這裡採取 Soft Delete 或直接刪除，此處直接刪除本地紀錄
      await isar.expenseCollections.filter().remoteIdEqualTo(id).deleteAll();
    });
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
