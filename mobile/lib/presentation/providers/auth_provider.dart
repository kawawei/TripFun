/// @file auth_provider.dart
/// @description 認證與使用者狀態管理 / Auth state management
/// @description_zh 管理當前登入的使用者，並處理切換使用者的邏輯
/// @description_en Manages current user state and switching logic
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user_entity.dart';

// 固定的成員名單
final tripMembers = [
  const UserEntity(id: 'u1', name: 'Kawa'),
  const UserEntity(id: 'u2', name: 'Kelly'),
  const UserEntity(id: 'u3', name: 'Amber'),
  const UserEntity(id: 'u4', name: 'Vivian'),
];

class AuthNotifier extends StateNotifier<UserEntity?> {
  AuthNotifier() : super(null) {
    _loadSavedUser();
  }

  Future<void> _loadSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final savedId = prefs.getString('current_user_id');
    if (savedId != null) {
      final user = tripMembers.where((u) => u.id == savedId).firstOrNull;
      if (user != null) {
        state = user;
      }
    }
  }

  Future<void> login(UserEntity user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_user_id', user.id);
    state = user;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user_id');
    state = null;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, UserEntity?>((ref) {
  return AuthNotifier();
});
