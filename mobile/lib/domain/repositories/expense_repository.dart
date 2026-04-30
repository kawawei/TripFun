import '../../data/models/expense_entry.dart';

/**
 * @file expense_repository.dart
 * @description 記帳倉庫接口 / Expense repository interface
 * @description_zh 定義記帳相關的數據操作規範
 * @description_en Defines data operation specifications for accounting
 */

abstract class ExpenseRepository {
  Future<List<ExpenseEntry>> getExpenses(String tripId);
  Future<void> syncExpenses(String tripId, List<ExpenseEntry> localExpenses);
  Future<void> deleteExpense(String id);
}
