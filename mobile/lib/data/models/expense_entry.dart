/**
 * @file expense_entry.dart
 * @description 支出分錄模型 / Expense entry model
 * @description_zh 定義每一筆支出的數據結構，包含金額、幣別、分類與時間
 * @description_en Defines the data structure for each expense entry, including amount, currency, category, and time
 */

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

enum ExpenseCategory {
  food('餐飲', LucideIcons.utensils, Colors.orange),
  transport('交通', LucideIcons.car, Colors.blue),
  accommodation('住宿', LucideIcons.home, Colors.purple),
  shopping('購物', LucideIcons.shoppingBag, Colors.pink),
  entertainment('娛樂', LucideIcons.ticket, Colors.green),
  other('其他', LucideIcons.moreHorizontal, Colors.grey);

  final String label;
  final IconData icon;
  final Color color;

  const ExpenseCategory(this.label, this.icon, this.color);
}

class ExpenseEntry {
  final String id;
  final double amount;
  final String currency;
  final double amountInBaseCurrency; // 換算後的主幣別金額 (如 TWD)
  final ExpenseCategory category;
  final String title;
  final String? note;
  final DateTime dateTime;

  ExpenseEntry({
    required this.id,
    required this.amount,
    required this.currency,
    required this.amountInBaseCurrency,
    required this.category,
    required this.title,
    this.note,
    required this.dateTime,
  });

  // 轉換為 JSON 方便存儲
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'currency': currency,
      'amountInBaseCurrency': amountInBaseCurrency,
      'category': category.name,
      'title': title,
      'note': note,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  // 從 JSON 恢復
  factory ExpenseEntry.fromJson(Map<String, dynamic> json) {
    return ExpenseEntry(
      id: json['id'],
      amount: json['amount'],
      currency: json['currency'],
      amountInBaseCurrency: json['amountInBaseCurrency'],
      category: ExpenseCategory.values.firstWhere((e) => e.name == json['category']),
      title: json['title'],
      note: json['note'],
      dateTime: DateTime.parse(json['dateTime']),
    );
  }
}
