/**
 * @file add_expense_dialog.dart
 * @description 新增支出對話框 / Add Expense Dialog
 * @description_zh 提供新增支出的表單，包含金額、幣別、分類與自動匯率換算
 * @description_en Provides a form to add expenses, including amount, currency, category, and automatic rate conversion
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../providers/accounting_provider.dart';
import '../../../data/models/expense_entry.dart';
import '../../../data/services/currency_service.dart';

class AddExpenseDialog extends ConsumerStatefulWidget {
  const AddExpenseDialog({super.key});

  @override
  ConsumerState<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends ConsumerState<AddExpenseDialog> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _currencyService = CurrencyService();

  ExpenseCategory _selectedCategory = ExpenseCategory.food;
  String _currency = 'TWD';
  double _exchangeRate = 1.0;
  bool _isLoadingRate = false;

  static const Map<String, String> _currencyNames = {
    'TWD': '新台幣',
    'JPY': '日圓',
    'USD': '美元',
    'KRW': '韓元',
    'EUR': '歐元',
    'HKD': '港幣',
    'CNY': '人民幣',
    'THB': '泰銖',
  };

  @override
  void initState() {
    super.initState();
    if (_currency != 'TWD') _fetchRate();
  }

  Future<void> _fetchRate() async {
    if (_currency == 'TWD') {
      setState(() => _exchangeRate = 1.0);
      return;
    }

    setState(() => _isLoadingRate = true);
    final data = await _currencyService.getExchangeRates(_currency);
    if (data != null && data['rates'] != null) {
      setState(() {
        _exchangeRate = (data['rates']['TWD'] as num).toDouble();
        _isLoadingRate = false;
      });
    } else {
      setState(() => _isLoadingRate = false);
    }
  }

  void _submit() {
    final title = _titleController.text.trim();
    final amountText = _amountController.text.trim();
    
    if (title.isEmpty || amountText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('請填寫標題與金額')),
      );
      return;
    }

    final amount = double.tryParse(amountText) ?? 0;
    if (amount <= 0) return;

    ref.read(accountingProvider.notifier).addEntry(
      amount: amount,
      currency: _currency,
      amountInBaseCurrency: amount * _exchangeRate,
      category: _selectedCategory,
      title: title,
      note: _noteController.text.trim(),
      dateTime: DateTime.now(),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '新增支出',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(LucideIcons.x, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // 金額與幣別 / Amount & Currency
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    autofocus: true,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlignVertical: TextAlignVertical.center,
                    cursorHeight: 24,
                    decoration: const InputDecoration(
                      hintText: '0.00',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                      isDense: true,
                    ),
                  ),
                ),
                _buildCurrencyPicker(),
              ],
            ),
            
            if (_currency != 'TWD')
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _isLoadingRate 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(
                      '≈ TWD ${((double.tryParse(_amountController.text) ?? 0) * _exchangeRate).toStringAsFixed(0)} (匯率: $_exchangeRate)',
                      style: TextStyle(color: Colors.grey[500], fontSize: 13),
                    ),
              ),
            
            const Divider(),
            const SizedBox(height: 16),
  
            // 標題 / Title
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: '這筆錢花在哪裡？',
                prefixIcon: const Icon(LucideIcons.edit3, size: 20),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 16),
  
            // 分類選擇 / Category Selection
            const Text('分類', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 12),
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: ExpenseCategory.values.length,
                itemBuilder: (context, index) {
                  final cat = ExpenseCategory.values[index];
                  final isSelected = _selectedCategory == cat;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: Container(
                      width: 70,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? cat.color.withValues(alpha: 0.1) : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: isSelected ? cat.color : Colors.grey.shade200),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(cat.icon, color: isSelected ? cat.color : Colors.grey),
                          const SizedBox(height: 4),
                          Text(
                            cat.label,
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected ? cat.color : Colors.grey,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
  
            // 備註 / Note (可選)
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                hintText: '備註 (可選)',
                prefixIcon: const Icon(LucideIcons.stickyNote, size: 20),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text('新增紀錄', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyPicker() {
    return PopupMenuButton<String>(
      initialValue: _currency,
      onSelected: (String code) {
        setState(() => _currency = code);
        _fetchRate();
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      itemBuilder: (context) => _currencyNames.entries.map((entry) {
        return PopupMenuItem(
          value: entry.key,
          child: Text('${entry.value} (${entry.key})'),
        );
      }).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(_currency, style: const TextStyle(fontWeight: FontWeight.bold)),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
