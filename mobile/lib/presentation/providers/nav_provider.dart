/// @file nav_provider.dart
/// @description 底部導覽欄狀態管理 / Bottom navigation bar state management
/// @description_zh 管理當前選中的導覽標籤索引
/// @description_en Manages the currently selected navigation tab index

import 'package:flutter_riverpod/flutter_riverpod.dart';

/**
 * @description 當前選中的導覽索引 Provider / Provider for current selected navigation index
 * @description_zh 提供並管理底部導覽欄的整數索引值
 */
final navigationIndexProvider = StateProvider<int>((ref) => 0);
