/// @file auth_provider.dart
/// @description 認證與使用者狀態管理 / Auth state management
/// @description_zh 管理當前登入的使用者，並處理切換使用者的邏輯
/// @description_en Manages current user state and switching logic
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user_entity.dart';
import '../../core/providers/dio_provider.dart';

final tripMembersProvider = FutureProvider<List<UserEntity>>((ref) async {
  final dio = ref.watch(dioProvider);
  try {
    // 嚴格要求不使用硬編碼，全由後端回傳
    final response = await dio.get('/trips/44444444-4444-4444-4444-444444444444/members');
    final List<dynamic> data = response.data;
    return data.map((json) => UserEntity(id: json['id'], name: json['name'])).toList();
  } catch (e) {
    print('Failed to fetch members from backend: $e');
    throw Exception('無法獲取成員資料，請確認後端伺服器是否已更新');
  }
});

class AuthNotifier extends StateNotifier<UserEntity?> {
  AuthNotifier() : super(null) {
    _loadSavedUser();
  }

  Future<void> _loadSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final savedId = prefs.getString('current_user_id');
    final savedName = prefs.getString('current_user_name');
    if (savedId != null && savedName != null) {
      state = UserEntity(id: savedId, name: savedName);
    }
  }

  Future<void> login(UserEntity user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_user_id', user.id);
    await prefs.setString('current_user_name', user.name);
    state = user;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user_id');
    await prefs.remove('current_user_name');
    state = null;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, UserEntity?>((ref) {
  return AuthNotifier();
});
