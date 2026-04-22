/**
 * @file packing_item.dart
 * @description 行李清單數據模型 / Packing list data model
 * @description_zh 定義行李項目及其狀態，支援預設項目與用戶自定義項目
 * @description_en Defines packing items and their states, supporting default and custom items
 */

class PackingItem {
  final String id;
  final String title;
  final bool isChecked;
  final String category;
  final bool isCustom;

  PackingItem({
    required this.id,
    required this.title,
    this.isChecked = false,
    required this.category,
    this.isCustom = false,
  });

  PackingItem copyWith({
    String? id,
    String? title,
    bool? isChecked,
    String? category,
    bool? isCustom,
  }) {
    return PackingItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isChecked: isChecked ?? this.isChecked,
      category: category ?? this.category,
      isCustom: isCustom ?? this.isCustom,
    );
  }
}
