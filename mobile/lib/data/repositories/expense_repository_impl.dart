import 'package:dio/dio.dart';
import '../../domain/repositories/expense_repository.dart';
import '../models/expense_entry.dart';
import '../dtos/expense_dto.dart';
import '../../core/providers/dio_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/**
 * @file expense_repository_impl.dart
 * @description 記帳倉庫實作 / Expense repository implementation
 * @description_zh 實作從 API 同步記帳數據的邏輯
 * @description_en Implements logic for syncing accounting data via API
 */

class ExpenseRepositoryImpl implements ExpenseRepository {
  final Dio _dio;

  ExpenseRepositoryImpl(this._dio);

  @override
  Future<List<ExpenseEntry>> getExpenses(String tripId) async {
    try {
      final response = await _dio.get('/accounting/trip/$tripId');
      final List<dynamic> data = response.data;
      return data.map((json) => ExpenseDto.fromJson(json).toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> syncExpenses(String tripId, List<ExpenseEntry> localExpenses) async {
    try {
      final dtos = localExpenses.map((e) => ExpenseDto.fromEntity(e, tripId).toJson()).toList();
      await _dio.post('/accounting/sync', data: dtos);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteExpense(String id) async {
    try {
      await _dio.delete('/accounting/$id');
    } catch (e) {
      rethrow;
    }
  }
}

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ExpenseRepositoryImpl(dio);
});
