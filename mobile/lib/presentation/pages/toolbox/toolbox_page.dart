/**
 * @file toolbox_page.dart
 * @description 旅遊工具箱頁面 / Travel Toolbox page
 * @description_zh 提供常用旅遊工具入口，如匯率換算、記帳、清單等
 * @description_en Provides access to common travel tools such as currency, expenses, and checklists
 */

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'currency_converter_page.dart';
import 'accounting/accounting_page.dart';
import 'world_clock_page.dart';
import 'translator_page.dart';
import 'packing_list_page.dart';
// import 'security_credentials_page.dart';

class ToolboxPage extends StatelessWidget {
  const ToolboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('旅遊工具箱'),
      ),
      body: CustomScrollView(
        slivers: [
          // 頂部橫幅 / Top Banner or Header
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '智慧旅遊助手',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '精選實用工具，讓您的旅程更輕鬆、更高效。',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 工具網格 / Tools Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.95,
              ),
              delegate: SliverChildListDelegate([
                _buildToolCard(
                  context,
                  title: '匯率換算',
                  subtitle: '即時匯率更新',
                  icon: LucideIcons.banknote,
                  color: Colors.blue,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CurrencyConverterPage(),
                    ),
                  ),
                ),
                _buildToolCard(
                  context,
                  title: '旅行記帳',
                  subtitle: '管理旅程支出',
                  icon: LucideIcons.calculator,
                  color: Colors.orange,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AccountingPage(),
                    ),
                  ),
                ),
                _buildToolCard(
                  context,
                  title: '打包清單',
                  subtitle: '出發前不再遺漏',
                  icon: LucideIcons.checkSquare,
                  color: Colors.green,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PackingListPage(),
                    ),
                  ),
                ),
                /*
                _buildToolCard(
                  context,
                  title: '安全憑證',
                  subtitle: '證件、機票備份',
                  icon: LucideIcons.shieldCheck,
                  color: Colors.indigo,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SecurityCredentialsPage(),
                    ),
                  ),
                ),
                */

                _buildToolCard(
                  context,
                  title: '世界時區',
                  subtitle: '兩地時差切換',
                  icon: LucideIcons.clock,
                  color: Colors.purple,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WorldClockPage(),
                    ),
                  ),
                ),
                _buildToolCard(
                  context,
                  title: '即時翻譯',
                  subtitle: '語言溝通無障礙',
                  icon: LucideIcons.languages,
                  color: Colors.red,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TranslatorPage(),
                    ),
                  ),
                ),
              ]),
            ),
          ),
          
          // 底部間距 / Bottom Spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
    );
  }

  Widget _buildToolCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.shade100),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
