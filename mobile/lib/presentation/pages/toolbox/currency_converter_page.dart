/**
 * @file currency_converter_page.dart
 * @description 匯率換算工具頁面 / Currency Converter page
 * @description_zh 提供即時的旅遊匯率換算功能
 * @description_en Provides real-time currency conversion for travelers
 */

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../data/services/currency_service.dart';
import '../../../core/constants/colors.dart';

class CurrencyConverterPage extends StatefulWidget {
  const CurrencyConverterPage({super.key});

  @override
  State<CurrencyConverterPage> createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  final TextEditingController _amountController = TextEditingController(text: '100');
  final CurrencyService _currencyService = CurrencyService();
  
  String _fromCurrency = 'TWD';
  String _toCurrency = 'JPY';
  double _exchangeRate = 4.65;
  bool _isLoading = true;
  String? _lastUpdateTime;

  // 幣別名稱對照表 / Currency names mapping
  static const Map<String, String> _currencyNames = {
    'TWD': '新台幣',
    'JPY': '日圓',
    'USD': '美元',
    'KRW': '韓元',
    'EUR': '歐元',
    'HKD': '港幣',
    'CNY': '人民幣',
    'GBP': '英鎊',
    'AUD': '澳幣',
    'CAD': '加幣',
    'SGD': '新加坡幣',
    'THB': '泰銖',
    'VND': '越南盾',
  };

  @override
  void initState() {
    super.initState();
    _fetchRate();
  }

  Future<void> _fetchRate() async {
    setState(() => _isLoading = true);
    final data = await _currencyService.getExchangeRates(_fromCurrency);
    
    if (data != null && data['rates'] != null) {
      setState(() {
        _exchangeRate = (data['rates'][_toCurrency] as num).toDouble();
        _lastUpdateTime = data['time_last_update_utc'];
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('無法獲取最新匯率，請檢查網路連線')),
        );
      }
    }
  }

  void _swapCurrencies() {
    setState(() {
      final temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
    });
    _fetchRate();
  }

  void _updateTargetCurrency(String code) {
    setState(() {
      _toCurrency = code;
    });
    _fetchRate();
  }

  double get _convertedAmount {
    final amount = double.tryParse(_amountController.text) ?? 0;
    return amount * _exchangeRate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('匯率換算'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.refreshCw, size: 20),
            onPressed: _fetchRate,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isLoading)
            const LinearProgressIndicator(minHeight: 2),
            
          // 轉換卡片區域 / Conversion Card Area
          Container(
            padding: const EdgeInsets.all(20),
            color: Theme.of(context).appBarTheme.backgroundColor,
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // 來源幣別 / From Currency
                    _buildCurrencyInput(
                      label: '從',
                      currency: _fromCurrency,
                      controller: _amountController,
                      isInput: true,
                      isFrom: true,
                    ),
                    
                    // 中間切換按鈕 / Swap Button
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Divider(color: Colors.grey.shade100),
                          GestureDetector(
                            onTap: _swapCurrencies,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(LucideIcons.arrowUpDown, color: Colors.white, size: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // 目標幣別 / To Currency
                    _buildCurrencyInput(
                      label: '到',
                      currency: _toCurrency,
                      value: _convertedAmount.toStringAsFixed(2),
                      isInput: false,
                      isFrom: false,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 匯率資訊 / Rate Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Icon(LucideIcons.info, size: 16, color: Colors.grey.shade400),
                const SizedBox(width: 8),
                Text(
                  '當前匯率：1 $_fromCurrency = ${_exchangeRate.toStringAsFixed(4)} $_toCurrency',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                const Spacer(),
                if (_lastUpdateTime != null)
                  Text(
                    '更新於 ${(_lastUpdateTime!).substring(5, 16)}',
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
                  ),
              ],
            ),
          ),

          const Spacer(),
          
          // 常用快捷幣別 / Common Currencies
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '常用幣別',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                'TWD', 'JPY', 'USD', 'KRW', 'EUR', 'HKD', 'CNY'
              ].map((code) => _buildQuickCurrencyTag(code)).toList(),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildCurrencyInput({
    required String label,
    required String currency,
    TextEditingController? controller,
    String? value,
    required bool isInput,
    required bool isFrom,
  }) {
    // 獲取顯示名稱 / Get display name
    final displayName = _currencyNames[currency] ?? currency;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
              const SizedBox(height: 8),
              isInput
                  ? TextField(
                      controller: controller,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        fillColor: Colors.transparent,
                      ),
                      onChanged: (v) => setState(() {}),
                    )
                  : Text(
                      value ?? '0',
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
            ],
          ),
        ),
        
        // 下拉選單按鈕 / Dropdown Menu Button
        PopupMenuButton<String>(
          initialValue: currency,
          onSelected: (String code) {
            setState(() {
              if (isFrom) {
                _fromCurrency = code;
              } else {
                _toCurrency = code;
              }
            });
            _fetchRate();
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          position: PopupMenuPosition.under,
          offset: const Offset(0, 8),
          itemBuilder: (BuildContext context) {
            return _currencyNames.entries.map((entry) {
              final isSelected = entry.key == currency;
              return PopupMenuItem<String>(
                value: entry.key,
                child: Row(
                  children: [
                    Text(
                      '${entry.value} (${entry.key})',
                      style: TextStyle(
                        color: isSelected ? Theme.of(context).primaryColor : AppColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    if (isSelected) ...[
                      const Spacer(),
                      Icon(Icons.check, color: Theme.of(context).primaryColor, size: 16),
                    ],
                  ],
                ),
              );
            }).toList();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$displayName ($currency)',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickCurrencyTag(String code) {
    final isSelected = _toCurrency == code;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(code),
        onPressed: () => _updateTargetCurrency(code),
        backgroundColor: isSelected ? Theme.of(context).primaryColor : Colors.white,
        side: BorderSide(color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade200),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.grey.shade700,
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
