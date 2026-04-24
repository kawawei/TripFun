/// @file create_trip_modal.dart
/// @description 建立行程彈窗 / Create trip modal
/// @description_zh 提供高品質的行程輸入介面，包含名稱、日期與描述
/// @description_en Provides a high-quality trip input interface, including name, dates, and description
library;

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/colors.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../pages/home/provider/home_provider.dart';
import '../../../domain/entities/trip_entity.dart';

class CreateTripModal extends ConsumerStatefulWidget {
  const CreateTripModal({super.key});

  @override
  ConsumerState<CreateTripModal> createState() => _CreateTripModalState();

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CreateTripModal(),
    );
  }
}

class _CreateTripModalState extends ConsumerState<CreateTripModal> {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController(); // 新增地點控制項
  final _descController = TextEditingController();
  DateTimeRange? _selectedDateRange;
  int _memberCount = 1; // 預設 1 人

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
      child: SingleChildScrollView( // 防止內容過多溢出
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
  
            // 目的地 / Location
            _buildFieldLabel(LucideIcons.mapPin, '目的地'),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                hintText: '例如：日本東京',
              ),
            ),
            const SizedBox(height: 20),
  
            // 日期選擇 / Date Range Selector
            _buildFieldLabel(LucideIcons.calendar, '出發與回程'),
            InkWell(
              onTap: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime.now().subtract(const Duration(days: 30)),
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
  
            // 旅客數量 / Member Count
            _buildFieldLabel(LucideIcons.users, '旅客數量'),
            Row(
              children: [
                _buildCountButton(LucideIcons.minus, () {
                  if (_memberCount > 1) setState(() => _memberCount--);
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    '$_memberCount 位',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                _buildCountButton(LucideIcons.plus, () {
                  setState(() => _memberCount++);
                }),
              ],
            ),
            const SizedBox(height: 32),
  
            // 確認按鈕 / Confirm Button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () async {
                  if (_nameController.text.isEmpty || _selectedDateRange == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('請填寫名稱並選擇日期')),
                    );
                    return;
                  }
  
                  final newTrip = TripEntity(
                    id: const Uuid().v4(),
                    title: _nameController.text,
                    location: _locationController.text,
                    startDate: _selectedDateRange!.start,
                    endDate: _selectedDateRange!.end,
                    memberCount: _memberCount,
                    iconName: 'palmtree',
                    colorValue: AppColors.primary.value,
                  );
  
                  try {
                    await ref.read(tripsProvider.notifier).addTrip(newTrip);
                    if (mounted) Navigator.pop(context);
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('儲存失敗: $e')),
                      );
                    }
                  }
                },
                child: const Text('準備出發！'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCountButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(icon, size: 18, color: AppColors.primary),
        onPressed: onPressed,
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
