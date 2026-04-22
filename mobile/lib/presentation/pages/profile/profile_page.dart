/**
 * @file profile_page.dart
 * @description 個人中心與設定頁面 / Profile and Settings page
 */

import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('個人中心')),
      body: const Center(
        child: Text('個人中心功能開發中...'),
      ),
    );
  }
}
