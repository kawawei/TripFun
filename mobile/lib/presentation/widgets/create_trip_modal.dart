/// @file create_trip_modal.dart
/// @description 建立行程彈窗 / Create trip modal
/// @description_zh 提供高品質的行程輸入介面，包含名稱、日期與描述
/// @description_en Provides a high-quality trip input interface, including name, dates, and description
library;

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/colors.dart';

class CreateTripModal extends StatefulWidget {
  const CreateTripModal({super.key});

  @override
  State<CreateTripModal> createState() => _CreateTripModalState();

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CreateTripModal(),
    );
  }
}

class _CreateTripModalState extends State<CreateTripModal> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  DateTimeRange? _selectedDateRange;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        top: 12,
        left: 24,
        right: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 頂部指示條 / Top Indicator
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '開始新的旅程',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 22),
          ),
          const SizedBox(height: 24),

          // 行程名稱 / Trip Name
          _buildFieldLabel(LucideIcons.edit3, '行程名稱'),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: '例如：東京之春美食之旅',
            ),
          ),
          const SizedBox(height: 20),

          // 日期選擇 / Date Range Selector
          _buildFieldLabel(LucideIcons.calendar, '出發與回程'),
          InkWell(
            onTap: () async {
              final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (picked != null) {
                setState(() => _selectedDateRange = picked);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDateRange == null
                          ? '選擇日期區間'
                          : '${_selectedDateRange!.start.toString().split(' ')[0]} 至 ${_selectedDateRange!.end.toString().split(' ')[0]}',
                      style: TextStyle(
                        color: _selectedDateRange == null
                            ? AppColors.textPlaceholder
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const Icon(LucideIcons.chevronRight, size: 18, color: AppColors.textSecondary),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 簡單備註 / Description
          _buildFieldLabel(LucideIcons.text, '描述（選填）'),
          TextField(
            controller: _descController,
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: '給這趟冒險一點註記吧...',
            ),
          ),
          const SizedBox(height: 32),

          // 確認按鈕 / Confirm Button
          FilledButton(
            onPressed: () {
              // TODO: 實作儲存邏輯
              Navigator.pop(context);
            },
            child: const Text('準備出發！'),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
