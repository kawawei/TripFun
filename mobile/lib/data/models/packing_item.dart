/**
 * @file packing_item.dart
 * @description 行理清單數據模型 / Packing list data model
 * @description_zh 定義行李項目及其狀態，支援預設項目與用戶自定義項目
 * @description_en Defines packing items and their states, supporting default and custom items
 */

class PackingItem {
  final String id;
  final String title;
  final bool isChecked;
  final String category;
  final bool isCustom;
  final String? tripId;
  final int sortOrder;

  PackingItem({
    required this.id,
    required this.title,
    this.isChecked = false,
    required this.category,
    this.isCustom = false,
    this.tripId,
    this.sortOrder = 0,
  });

  factory PackingItem.fromJson(Map<String, dynamic> json) {
    return PackingItem(
      id: json['id'] as String,
      title: json['title'] as String,
      isChecked: json['isChecked'] as bool? ?? false,
      category: json['category'] as String,
      isCustom: json['is_custom'] as bool? ?? false,
      tripId: json['trip_id'] as String?,
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isChecked': isChecked,
      'category': category,
      'is_custom': isCustom,
      'trip_id': tripId,
      'sort_order': sortOrder,
    };
  }

  PackingItem copyWith({
    String? id,
    String? title,
    bool? isChecked,
    String? category,
    bool? isCustom,
    String? tripId,
    int? sortOrder,
  }) {
    return PackingItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isChecked: isChecked ?? this.isChecked,
      category: category ?? this.category,
      isCustom: isCustom ?? this.isCustom,
      tripId: tripId ?? this.tripId,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
