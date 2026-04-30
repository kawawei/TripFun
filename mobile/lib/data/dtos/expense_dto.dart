import '../models/expense_entry.dart';

/**
 * @file expense_dto.dart
 * @description 記帳數據傳輸物件 / Expense Data Transfer Object
 * @description_zh 負責將後端 API 的 JSON 格式轉換為 App 端模型
 * @description_en Responsible for converting backend API JSON format to App side models
 */

class ExpenseDto {
  final String id;
  final String tripId;
  final String title;
  final double amount;
  final String currency;
  final double amountInBaseCurrency;
  final String category;
  final String? note;
  final DateTime dateTime;
  final String? userId;

  ExpenseDto({
    required this.id,
    required this.tripId,
    required this.title,
    required this.amount,
    required this.currency,
    required this.amountInBaseCurrency,
    required this.category,
    this.note,
    required this.dateTime,
    this.userId,
  });

  factory ExpenseDto.fromJson(Map<String, dynamic> json) {
    return ExpenseDto(
      id: json['id'],
      tripId: json['trip_id'],
      title: json['title'],
      amount: double.parse(json['amount'].toString()),
      currency: json['currency'],
      amountInBaseCurrency: double.parse(json['amount_in_base_currency'].toString()),
      category: json['category'],
      note: json['note'],
      dateTime: DateTime.parse(json['date_time']),
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trip_id': tripId,
      'title': title,
      'amount': amount,
      'currency': currency,
      'amount_in_base_currency': amountInBaseCurrency,
      'category': category,
      'note': note,
      'date_time': dateTime.toIso8601String(),
      'user_id': userId,
    };
  }

  ExpenseEntry toEntity() {
    return ExpenseEntry(
      id: id,
      amount: amount,
      currency: currency,
      amountInBaseCurrency: amountInBaseCurrency,
      category: ExpenseCategory.values.firstWhere(
        (e) => e.name == category,
        orElse: () => ExpenseCategory.other,
      ),
      title: title,
      note: note,
      dateTime: dateTime,
    );
  }

  factory ExpenseDto.fromEntity(ExpenseEntry entry, String tripId, {String? userId}) {
    return ExpenseDto(
      id: entry.id,
      tripId: tripId,
      title: entry.title,
      amount: entry.amount,
      currency: entry.currency,
      amountInBaseCurrency: entry.amountInBaseCurrency,
      category: entry.category.name,
      note: entry.note,
      dateTime: entry.dateTime,
      userId: userId,
    );
  }
}
