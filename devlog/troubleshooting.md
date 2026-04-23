# 問題追蹤 (Issue Tracking)

## 2026-04-23

### 後端容器化初始化：指令缺失與依賴同步問題 (Backend Containerization: Command Not Found & Dependency Sync)
- **問題描述 (Issue)**: 
  - `tripfun-backend` 啟動失敗，容器日誌顯示 `sh: nest: not found`。
  - Host 端 IDE 出現大量 `@nestjs/common` 等模組找不到的型別錯誤 (Lint Errors)。
  - `docker compose up` 執行時因 `busybox` 鏡像下載中斷導致服務無法啟動。
- **原因分析**:
  - **指令定位問題**：`package.json` 中的 `scripts` 直接使用 `nest` 指令，但在專案未全域安裝 `@nestjs/cli` 的容器環境中，必須透過 `pnpm exec` 才能正確調用 `node_modules/.bin` 下的二進制文件。
  - **環境隔離副作用**：由於開發策略為 Docker-First，本地 host 目錄最初沒有 `node_modules`，導致 IDE 解析失敗。
  - **網路不穩**：Docker Compose 在同時執行 Build 與 Pull 時，若網路不穩易導致層級下載中斷。
- **解決方案 (Solution)**:
  - **Dockerfile 修復**：將 `CMD` 改為 `pnpm exec nest start --watch`。
  - **IDE 報錯修復**：配合用戶要求在 host 端執行 `pnpm install` 補全型別宣告。
  - **鏡像與佔位處理**：手動執行 `docker pull busybox:latest` 確保資源就緒，並在 `compose.yaml` 中使用其作為 `chat` 服務的臨時佔位符。
- **驗證結果**:
  - 容器顯示 `tripfun-backend Up`。
  - API `http://localhost:9001/trips` 成功回傳預設 JSON 數據。
  - 本地 IDE 紅字消失。


### 安全憑證：編譯錯誤 (Compilation Error: Const & Typo)
- **問題描述 (Issue)**: 
  - 建立 `SecurityCredentialsPage` 後出現 `Cannot invoke a non-'const' constructor where a const expression is expected` 以及 `Member not found: 'whiteb70'` 錯誤。
- **原因分析**:
  - 錯誤地在 `Row` 前使用了 `const` 關鍵字，而子組件 `Container` 並非 `const` 構造函數。
  - 將 `Colors.white70` 誤打為 `Colors.whiteb70`。
- **解決方案 (Solution)**:
  - 移除 `Row` 前的 `const` 關鍵字。
  - 修正顏色拼寫為 `white70`。

### UI 異常：Web 佈局卡死與點擊無反應 (Layout Freeze & No Response)
- **問題描述 (Issue)**: 
  - 頁面渲染後，移動滑鼠導致控制台瘋狂出現 `Assertion failed: ...box.dart:2251:12`，且所有點擊事件（含返回鍵）均失效。
- **原因分析**:
  - **佈局衝突破潰**：在 `SingleChildScrollView` + `Column` 中使用了多個 `ListView/GridView` 並設定 `shrinkWrap: true`。在 Flutter Web 引擎下，這可能導致計算寬高度時無法收斂（呈現高度為 Infinity），進而讓 Hit-Testing 邏輯崩潰，UI 鎖死。
  - **狀態殘留**：先前的編譯錯誤導致 Flutter 引擎狀態異常，即便代碼修復後，Web 端若不重整瀏覽器，滑鼠追蹤器 (Mouse Tracker) 仍會因舊有的 RenderObject 資訊不符而報錯。
- **解決方案 (Solution)**:
  - **重構頁面**：棄用 `SingleChildScrollView`，改用高性能的 **`CustomScrollView` + `Sliver (SliverGrid/SliverList)`** 佈局，從根本上解決 Web 端的滾動佈局衝突。
  - **狀態重置**：指導用戶重新整理瀏覽器或執行 Hot Restart，清除舊有的報錯狀態。
  - **反饋強化**：加入 `ScaffoldMessenger.showSnackBar` 提供點擊時的視覺反饋。


### 即時翻譯：MissingPluginException 與 Web 插件加載問題 (Plugin Loading & Missing Plugin)
- **問題描述 (Issue)**: 
  - 在 Web 環境下新增 `flutter_tts` 套件後，呼叫語音功能出現 `MissingPluginException(No implementation found for method setLanguage on channel flutter_tts)`。
- **原因分析**:
  - Flutter Web 在新增 Plugin 後，僅靠代碼層級的 Hot Reload/Restart 無法載入對應的 JavaScript 綁定介面，必須完整重啟開發伺服器。
- **解決方案 (Solution)**:
  - 停止目前的 `flutter run` 並重新啟動，確保插件資源正確映射。
  - 在發音函數中加入 `try-catch` 保護，防止插件未準備好時導致應用崩潰。

### 語音功能：音質與性別不一致 (Voice Quality & Gender Inconsistency)
- **問題描述 (Issue)**: 
  - 語音播放時，第一次可能是高品質女聲，但隨後會變成沙啞男聲。
- **原因分析**:
  - `flutter_tts` 在未指定 `setVoice` 的情況下，會隨機使用系統預設聲音。部分瀏覽器預設引擎不穩定。
- **解決方案 (Solution)**:
  - 實作語音選取邏輯，掃描所有可用聲音並優先過濾名稱包含 "Female" 或 "Google" 的高品質語音，強制固定發音人。

### 匯率換算：JS Runtime 與編譯錯誤 (Runtime & Compilation Errors)
- **問題描述 (Issue)**: 
  - **JS Error**: 在 Web 環境下出現 `TypeError: Cannot read properties of undefined (reading 'Symbol(dartx._get)')`。
  - **Const Error**: `showModalBottomSheet` 中的 `RoundedRectangleBorder` 使用 `const` 時，內部的 `BorderRadius.circular` 在部分 SDK 環境下報錯。
- **原因分析**:
  - Web 編譯器在存取類別內的 `final` Map 時，若該變數非 `static`，在某些生命週期階段存取會導致未定義錯誤。
  - `BorderRadius.circular` 是否能作為 `const` 內容取決於使用的 Flutter SDK 版本，為確保最大相容性，不應在建構子中使用 `const` 若其包含此動態屬性。
- **解決方案 (Solution)**:
  - 將 `_currencyNames` 對照表改為 `static const` 類型，確保其在類別載入時即可被安全存取。
  - 移除 `RoundedRectangleBorder` 前的 `const` 關鍵字。

### 開發錯誤：導入路徑層級誤判 (Invalid Import Path)
- **問題描述 (Issue)**: 
  - 在 `AddExpenseDialog.dart` 中嘗試導入 `AccountingProvider` 時報錯：`No such file or directory`。
- **原因分析**:
  - 錯誤地將位於 `lib/presentation/pages/toolbox/` 的檔案連跳三層 `../../../` 試圖進入 `lib/presentation/providers/`，實際上只需跳兩層 `../../` 即可到達 `presentation` 層級。
- **解決方案 (Solution)**:
  - 修正導入路徑為 `import '../../providers/accounting_provider.dart';`，並同步修正其他 `data/` 層級的路徑為三層 `../../../`。

### UI 異常：金額輸入框游標偏移與過長 (Cursor Layout Issue)
- **問題描述 (Issue)**: 
  - 金額輸入框在使用 32px 大字體時，游標長度過長且提示文字 `hintText` 在部分平台發生偏移，游標看起來超出了輸入框範圍。
- **原因分析**:
  - `TextField` 的預設 `cursorHeight` 是根據字體高度生成的，且 `contentPadding: EdgeInsets.zero` 可能導致文字被裁切。
- **解決方案 (Solution)**:
  - 將 `fontSize` 稍微調降至 `28`，並加入 `textAlignVertical: TextAlignVertical.center`。
  - 手動限制 `cursorHeight: 24` 以縮短游標長度。
  - 設定 `contentPadding: EdgeInsets.symmetric(vertical: 8)` 增加呼吸空間。

### 世界時區：在地定位失效與數據未加載 (Location & Data Missing)
- **問題描述 (Issue)**: 
  - 進入頁面後，全球所有城市顯示的時間均與本地一致（Offset 為 0），且標註「時區數據更新中」。
- **原因分析**:
  - `timezone` 套件在 `WorldClockPage` 中未使用準確的在地時區標識符 (`Asia/Taipei` 等)，僅依賴 `DateTime.now()` 會導致與目標時區比對邏輯失效。
  - `tz.local` 預設為 UTC，若未手動配置設備所在時區，對比結果永遠為 0。
- **解決方案 (Solution)**:
  - 引入 `flutter_native_timezone` 2.0.0。
  - 在 `WorldClockPage` 初始化時非同步獲取 `getLocalTimezone()` 並設定為基準時區。
  - 優化 `_getTimeDiff` 邏輯，明確對比兩地的時區對象而非單一 Offset。

### UI 異常：時區頁面佈局溢出與資源 404 (Layout Overflow & Asset 404)
- **問題描述 (Issue)**: 
  - Web 端點擊 InkWell 或頁面加載時出現 `RenderFlex needs layout` 崩潰聲明。
  - 控制台出現多個 Icon 字型 404 錯誤。
- **原因分析**:
  - 資源問題：新增 Native 套件後未重啟 Dev Server，導致 Web 端字型資源映射失敗。
  - 佈局問題：時區名稱長度不一，在 `Row` 中未使用 `Flexible` 約束，導致排版引擎無法計算寬度邊界。
- **解決方案 (Solution)**:
  - 指導用戶執行 `flutter clean` 並重啟應用程式以同步資源。
  - 為時區名稱 Text 加入 `Flexible` 與 `TextOverflow.ellipsis` 保護。
  - 使用 `FittedBox` 縮放大時鐘文字。

### 介面佈局：首頁行程卡片垂直溢出 (RenderFlex Overflow)
- **問題描述 (Issue)**: 
  - 在小螢幕或內容文字較多時，行程卡片出現 `A RenderFlex overflowed by 2.0 pixels on the bottom` 警告。
- **原因分析**:
  - 使用了 `IntrinsicHeight` 與 `Spacer()`，導致內容高度被強行約束。當文字標題過長換行時，總高度超過了卡片上限。
- **解決方案 (Solution)**:
  - 移除 `IntrinsicHeight`，改為使用 `minHeight` 約束。
  - 為標題和地點文字加上 `maxLines: 1` 與 `TextOverflow.ellipsis`，防止無限向下延伸。
  - 移除 `Spacer()` 取代為固定高度的 `SizedBox`，讓卡片高度隨內容自動撐開。


## 2026-04-22

### UI 視覺偏差：導航欄與按鈕主要顏色偏紫 (Visual Hue Mismatch)
- **問題描述 (Issue)**: 
  - 使用者反饋導航欄選中塊與按鈕顏色看起來像「紫色」而非預期的「藍色」。
  - **原因分析**:
    1. 原本使用的 `AppColors.primary` (#6366F1) 屬於「靛藍色 (Indigo)」，在色譜上本就介於藍、紫之間，內含紅色成份較多，在部分螢幕上會產生紫色感。
    2. Material 3 預設的 `primaryContainer` 是由種子色自動生成的淡化色調，視覺上更接近「淡紫色 (Lavender)」。
- **解決方案 (Solution)**:
  - 將品牌主色 `AppColors.primary` 更換為飽和度更高、不偏紅的 **「純正活力藍 (#0066FF)」**。
  - 在 `app_theme.dart` 中手動設定 `ColorScheme`，將 `primary` 與 `primaryContainer` 統一，避免系統自動生成淡紫色偏差。
  - 顯式定義 `NavigationBarTheme` 與 `FloatingActionButtonTheme` 的配件顏色。


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
