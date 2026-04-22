/**
 * @file explore_page.dart
 * @description 探索與百科頁面 / Explore and Wiki page
 */

import 'package:flutter/material.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('探索目的地')),
      body: const Center(
        child: Text('探索功能開發中...'),
      ),
    );
  }
}
