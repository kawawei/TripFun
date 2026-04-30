/**
 * @file accounting_provider.dart
 * @description 記帳狀態管理 / Accounting state management
 * @description_zh 管理支出清單數據，包含新增、刪除與統計邏輯，支援 Isar 本地持久化與雲端同步
 * @description_en Manages expense list data, including add, delete, and statistics logic, supporting Isar local persistence and cloud sync
 */

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../data/models/expense_entry.dart';
import '../../data/local/isar_service.dart';
import '../../data/local/collections/expense_collection.dart';
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
      // Web 端若不支援 Isar，可考慮直接調用 API
      _syncSingleEntry(entry, tripId ?? 'default');
      return;
    }
    
    final isar = await IsarService.instance;
    if (isar == null) return;
    await isar.writeTxn(() async {
      final collection = ExpenseCollection()
        ..remoteId = newId
        ..tripId = tripId ?? 'default'
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

    final isar = await IsarService.instance;
    if (isar == null) return;
    await isar.writeTxn(() async {
      // 標記為已刪除 (Soft Delete) 以便同步刪除至雲端，或者直接刪除
      // 這裡為了簡單先直接刪除本地，並嘗試調用 API
      await isar.expenseCollections.filter().remoteIdEqualTo(id).deleteAll();
    });

    try {
      await _ref.read(expenseRepositoryProvider).deleteExpense(id);
    } catch (_) {
      // 如果刪除失敗（如斷網），可以在後續同步邏輯中處理
    }
  }

  // 4. 與雲端同步
  Future<void> syncWithCloud({String? tripId}) async {
    if (kIsWeb) return;
    
    final currentTripId = tripId ?? '44444444-4444-4444-4444-444444444444'; // 預設測試 ID
    final isar = await IsarService.instance;
    if (isar == null) return;

    try {
      // A. 獲取本地未同步的數據
      final unsynced = await isar.expenseCollections
          .filter()
          .isSyncedEqualTo(false)
          .isDeletedEqualTo(false)
          .findAll();

      if (unsynced.isNotEmpty) {
        final entriesToSync = unsynced.map((c) => ExpenseEntry(
          id: c.remoteId!,
          amount: c.amount,
          currency: c.currency,
          amountInBaseCurrency: c.amountInBaseCurrency,
          category: ExpenseCategory.values.firstWhere((e) => e.name == c.category),
          title: c.title,
          note: c.note,
          dateTime: c.dateTime,
        )).toList();

        await _ref.read(expenseRepositoryProvider).syncExpenses(currentTripId, entriesToSync);

        // 更新本地狀態為已同步
        await isar.writeTxn(() async {
          for (var item in unsynced) {
            item.isSynced = true;
            await isar.expenseCollections.putByRemoteId(item);
          }
        });
      }

      // B. 從雲端拉取最新數據 (可選，視需求而定)
      // final remoteEntries = await _ref.read(expenseRepositoryProvider).getExpenses(currentTripId);
      // TODO: 實作合併邏輯
      
    } catch (e) {
      print('Sync failed: $e');
    }
  }

  // 單筆同步 (用於 Web 或 立即同步)
  Future<void> _syncSingleEntry(ExpenseEntry entry, String tripId) async {
    try {
      await _ref.read(expenseRepositoryProvider).syncExpenses(tripId, [entry]);
    } catch (_) {}
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
