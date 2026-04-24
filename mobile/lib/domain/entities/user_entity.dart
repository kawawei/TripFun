/// @file user_entity.dart
/// @description 使用者領域模型 / User domain entity
/// @description_zh 定義登入使用者的核心業務資料結構
/// @description_en Defines the core business data structure of a user
library;

class UserEntity {
  final String id;
  final String name;

  const UserEntity({
    required this.id,
    required this.name,
  });
}
