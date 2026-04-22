/**
 * @file packing_list_provider.dart
 * @description 行李清單狀態管理 / Packing list state management
 * @description_zh 管理行李清單數據，包含初始化、切換狀態與新增自定義項目
 * @description_en Manages packing list data, including initialization, toggling state, and adding custom items
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/packing_item.dart';
import 'package:uuid/uuid.dart';

final packingListProvider = StateNotifierProvider<PackingListNotifier, List<PackingItem>>((ref) {
  return PackingListNotifier();
});

class PackingListNotifier extends StateNotifier<List<PackingItem>> {
  PackingListNotifier() : super([]) {
    _initializeDefaultItems();
  }

  final _uuid = const Uuid();

  void _initializeDefaultItems() {
    state = [
      // 重要證件與金流
      PackingItem(id: '1', title: '護照 (及其影本)', category: '重要證件與金流'),
      PackingItem(id: '2', title: '美簽 (ESTA/Visa)', category: '重要證件與金流'),
      PackingItem(id: '3', title: '韓簽 (K-ETA)', category: '重要證件與金流'),
      PackingItem(id: '4', title: '國際機票 (電子/紙本)', category: '重要證件與金流'),
      PackingItem(id: '5', title: '外幣現金 (USD, KRW)', category: '重要證件與金流'),
      PackingItem(id: '6', title: '信用卡 (海外刷卡推薦)', category: '重要證件與金流'),
      
      // 電子產品與配件
      PackingItem(id: '7', title: '萬用轉接頭 (美國與台灣相同，韓國為歐規)', category: '電子產品與配件'),
      PackingItem(id: '8', title: '變壓器 (注意韓國為 220V)', category: '電子產品與配件'),
      PackingItem(id: '9', title: '行動電源', category: '電子產品與配件'),
      PackingItem(id: '10', title: '多孔充電頭與線材', category: '電子產品與配件'),
      PackingItem(id: '11', title: 'eSIM / 網卡 / Wi-Fi 分享器', category: '電子產品與配件'),
      
      // 個人衣物與穿戴
      PackingItem(id: '12', title: '換洗衣物', category: '個人衣物與穿戴'),
      PackingItem(id: '13', title: '保暖外套 (美國長程航程冷, 韓國四季分明)', category: '個人衣物與穿戴'),
      PackingItem(id: '14', title: '舒適運動鞋', category: '個人衣物與穿戴'),
      PackingItem(id: '15', title: '太陽眼鏡', category: '個人衣物與穿戴'),
      
      // 盥洗物品
      PackingItem(id: '16', title: '牙刷、牙膏 (美國飯店常不提供)', category: '盥洗物品'),
      PackingItem(id: '17', title: '洗面乳、個人護膚品', category: '盥洗物品'),
      PackingItem(id: '18', title: '防曬乳', category: '盥洗物品'),
      PackingItem(id: '19', title: '刮鬍刀', category: '盥洗物品'),
      
      // 常備藥品與防疫
      PackingItem(id: '20', title: '感冒藥、止痛藥', category: '常備藥品與防疫'),
      PackingItem(id: '21', title: '腸胃藥', category: '常備藥品與防疫'),
      PackingItem(id: '22', title: '個人長期服用藥物', category: '常備藥品與防疫'),
      PackingItem(id: '23', title: '口罩與乾洗手', category: '常備藥品與防疫'),
      
      // 旅遊票券與計畫
      PackingItem(id: '24', title: '飯店預約單', category: '旅遊票券與計畫'),
      PackingItem(id: '25', title: '旅遊保險證明', category: '旅遊票券與計畫'),
      PackingItem(id: '26', title: '主題樂園/門票 (如迪士尼、環球影城)', category: '旅遊票券與計畫'),
      
      // 長程飛行與生活雜物
      PackingItem(id: '27', title: '頸枕、眼罩 (美國長途必備)', category: '長程飛行與生活雜物'),
      PackingItem(id: '28', title: '環保購物袋 (韓國很多超市不提供塑膠袋)', category: '長程飛行與生活雜物'),
      PackingItem(id: '29', title: '空水壺 (入關後裝水)', category: '長程飛行與生活雜物'),
      
      // 目的地特定項目
      PackingItem(id: '30', title: 'T-Money卡 (韓國交通卡)', category: '目的地特定項目'),
      PackingItem(id: '31', title: 'Naver Map/Kakao Map (韓國導航)', category: '目的地特定項目'),
      PackingItem(id: '32', title: 'Uber/Lyft APP (美國叫車)', category: '目的地特定項目'),
    ];
  }

  void toggleItem(String id) {
    state = [
      for (final item in state)
        if (item.id == id)
          item.copyWith(isChecked: !item.isChecked)
        else
          item,
    ];
  }

  void addItem(String title, String category) {
    final newItem = PackingItem(
      id: _uuid.v4(),
      title: title,
      category: category,
      isCustom: true,
    );
    state = [...state, newItem];
  }

  void removeItem(String id) {
    state = state.where((item) => item.id != id).toList();
  }
}
