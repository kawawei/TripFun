# 問題追蹤 (Issue Tracking)

## 2026-04-22

### Flutter 編譯錯誤：CardTheme 類型不匹配 (Compilation Error)
- **問題描述 (Issue)**: 
  - 在 `lib/core/theme/app_theme.dart` 中，發生 `The argument type 'CardTheme' can't be assigned to the parameter type 'CardThemeData?'` 錯誤。
  - 原因分析：在較新版本的 Flutter (Material 3) 中，`ThemeData` 的 `cardTheme` 屬性已更改為期待 `CardThemeData` 類型，而不再是 `CardTheme`。
- **解決方案 (Solution)**:
  - 將 `app_theme.dart` 中的 `CardTheme(...)` 改為 `CardThemeData(...)`。

### 依賴項衝突：lucide_icons 與 intl (Dependency Conflict)
- **問題描述 (Issue)**: 
  - `lucide_icons ^0.320.0` 版本找不到，且 `intl` 與 `flutter_localizations` 發生版本衝突。
- **解決方案 (Solution)**:
  - 將 `lucide_icons` 降級至 `^0.257.0`。
  - 將 `intl` 設置為 `any` 或指定的相容版本（如 `0.20.2`）以解決 `flutter_localizations` 的約束。
  - 運行 `flutter pub get` 重新解析依賴。

## 2026-04-21

### Mermaid 語法錯誤 (Section 1) - 第二次修復
- **問題描述 (Issue)**: 
  - 即使改為 `flowchart TD` 並添加引號，Section 1 仍顯示 "Syntax error in graph"。
  - 原因進階分析：
    1. 部分 Mermaid 版本對於 `-->|label|` 中的空格或引號組合極其敏感。
    2. 全形冒號 `：` 與特殊符號 `+` 在舊版解析器中即便在引號內也可能引發非預期行為。
    3. `-- "label" -->` 語法通常比 `-->|label|` 更具相容性。
- **解決方案 (Solution)**:
  - 將連線標籤語法統一改為 `-- "label" -->`。
  - 移除所有全形冒號 `：` 並改為空格。
  - 將 `+` 替換為文字 `加號`。
  - 移除標籤引號內的任何多餘空格。
