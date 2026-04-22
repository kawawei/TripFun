/// @file colors.dart
/// @description 全域配色常數 / Global color constants
/// @description_zh 定義專案使用的品牌色、功能色與中性色調
/// @description_en Defines brand, functional, and neutral colors used in the project
library;

import 'package:flutter/material.dart';

class AppColors {
  // 品牌色 / Brand Colors
  static const Color primary = Color(0xFF0066FF); // 純正活力藍 (不偏紫)
  static const Color primaryDark = Color(0xFF0052CC);
  static const Color secondary = Color(0xFF10B981); // 翡翠綠 (旅遊生機感)
  
  // 背景色 / Background Colors
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color cardBackground = Colors.white;

  // 文字色 / Text Colors
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textPlaceholder = Color(0xFF94A3B8);

  // 功能色 / Functional Colors
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // 邊框與裝飾 / Border & Decoration
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFF1F5F9);
}
