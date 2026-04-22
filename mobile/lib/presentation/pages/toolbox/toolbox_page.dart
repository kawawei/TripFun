/**
 * @file toolbox_page.dart
 * @description 旅遊工具箱頁面 / Travel Toolbox page
 */

import 'package:flutter/material.dart';

class ToolboxPage extends StatelessWidget {
  const ToolboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('旅遊工具箱')),
      body: const Center(
        child: Text('工具箱功能開發中...'),
      ),
    );
  }
}
