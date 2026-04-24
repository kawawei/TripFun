# 問題追蹤 (Issue Tracking)

## 2026-04-23

### Flutter 編譯錯誤：缺失 Material 導入 (Compilation Error: Missing Material Import)
- **問題描述 (Issue)**: 
  - 重構 `HomePage` 後出現大量錯誤：`The method 'Row' isn't defined for the type 'HomePage'`, `The getter 'Colors' isn't defined` 等。
- **原因分析**:
  - 在執行 `replace_file_content` 時，意外移除了文件頂部的 `import 'package:flutter/material.dart';`，導致所有基礎組件與佈局類別均無法識別。
- **解決方案 (Solution)**:
  - 在 `home_page.dart` 文件頂部補回 `import 'package:flutter/material.dart';`。
  - 同步清理 `trip_detail_page.dart` 中混亂的重複導入語句。

### Web 跨網域衝突：CORS 政策阻擋 (Web: CORS Policy Blocked)
- **問題描述 (Issue)**: 
  - 運行 Flutter Web 版時，請求後端 API 報錯：`Access to XMLHttpRequest at 'http://localhost:9001/trips' from origin 'http://localhost:3000' has been blocked by CORS policy`。
- **原因分析**:
  - 瀏覽器的安全性限制。Web 應用程式 (`localhost:3000`) 請求不同端口的後端 (`localhost:9001`) 時，若伺服器未明確聲明允許存取，則會被阻擋。
- **解決方案 (Solution)**:
  - 修改後端 `backend/src/main.ts`，在 `app.listen()` 前加入 `app.enableCors()`。

### 運行時異常：熱重載拒絕 (Runtime: Hot Reload Rejected)
- **問題描述 (Issue)**: 
  - 修改建構子後，控制台報錯：`Exception: Const class cannot remove fields: TripDetailPage`，且 UI 未更新。
- **原因分析**:
  - Flutter 的 **Hot Reload (熱重載)** 不支援對 `const` 類別建構子參數的結構性變更（原本為傳入 `title` 字串，改為傳入 `trip` 對象）。
- **解決方案 (Solution)**:
  - 執行 **Hot Restart (熱重啟)** 以重新加載所有狀態。


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
  - **模組缺失修復 (Module Missing Fix)**：
    - 問題：容器日誌報錯 `TS2307: Cannot find module '@nestjs/common'...`。
    - 原因：容器掛載了匿名的 `node_modules` 磁碟卷，但 Host 端的 `pnpm-lock.yaml` 更新後，磁碟卷內容未同步更新，導致連結失效。
    - 解決：在容器內執行 `docker exec tripfun-backend pnpm install` 強制刷新磁碟卷內容，並重啟容器。
- **驗證結果**:
  - 容器顯示 `tripfun-backend Up`，日誌顯示 `Nest application successfully started`。
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

## 2026-04-24

### Git 操作極其緩慢與 Index 鎖定 (Git Performance & Index Locked)
- **問題描述 (Issue)**: 
  - 執行 `git status` 需耗時 10-20 秒，且頻繁出現 `fatal: Unable to create '.git/index.lock': File exists`。
  - 出現 148 個非預期的 `staged delete` 變更。
- **原因分析**:
  - **Index 損壞/殘留**：先前執行 `git rm -r --cached` 時範圍過廣且中途可能因 Bus Error 異常中斷，導致 `.git/index.lock` 未被正確刪除，且 index 紀錄了大量刪除變更。
  - **監控程序干擾**：MacOS 的 `fsmonitor--daemon` 程序持續持有檔案鎖，導致 git 頻繁重試降低效能。
- **解決方案 (Solution)**:
  - **終止監控程序**：執行 `pkill git-fsmonitor` 釋放資源。
  - **清理鎖文件**：刪除 `.git/index.lock`。
  - **重建 Index**：刪除損壞的 `.git/index` 並執行 `git read-tree HEAD` 從最新的 commit 重建索引，恢復正確的 staged 狀態。
- **驗證結果**:
  - `git status` 恢復至 0.02 秒。
  - 異常的 staged delete 消失，僅保留正常的開發變更。

### Flutter Web 崩潰：color_value 型別不匹配 (TypeError: String is not subtype of num)
- **問題描述 (Issue)**:
  - 場景：Flutter Web App 啟動後，首頁顯示紅色錯誤畫面。
  - 錯誤訊息：`TypeError: '4279286145': type 'String' is not a subtype of type 'num'`

- **原因分析**:
  - `TripDto.fromJson` 中使用 `(json['color_value'] as num).toInt()` 強制型別轉換。
  - 後端 API 回傳的 `color_value` 欄位在 JSON 解析後為 **String** 型別，而非 `num`，導致 `as num` 直接拋出 TypeError。

- **解決方案**:
  - 修改 `mobile/lib/data/dtos/trip_dto.dart` 第 42 行，將型別轉換改為：
    ```dart
    // 修改前
    colorValue: json['color_value'] != null ? (json['color_value'] as num).toInt() : null,
    // 修改後
    colorValue: json['color_value'] != null ? int.tryParse(json['color_value'].toString()) : null,
    ```
  - 使用 `toString()` 先統一轉為字串，再用 `int.tryParse()` 安全轉換，相容 String 與 num 兩種輸入型別。

- **驗證結果**:
  - 執行 Hot Reload後，首頁成功載入行程卡片，不再出現 TypeError。

### 後端依賴損壞：pnpm JSON 解析錯誤 (pnpm: ERR_PNPM_JSON_PARSE)
- **問題描述 (Issue)**: 
  - 場景：在安裝後端 `multer` 及相關圖片處理套件時發生錯誤。
  - 錯誤訊息：` ERR_PNPM_JSON_PARSE  Unexpected end of JSON input while parsing empty string in .../eslint/package.json`。
- **原因分析**:
  - `node_modules` 內部緩存或檔案損壞。可能是先前安裝過程中斷導致 `eslint/package.json` 變為空檔案，使得 `pnpm` 無法正確解析元數據。
- **解決方案 (Solution)**:
  - 執行 `pnpm install` 觸發依賴完整檢查。
  - 若失效，理想解決方案是刪除 `node_modules` 並重建，但因權限問題受阻時，可透過重新安裝 (`pnpm add`) 目標套件來觸發局部重建。
- **驗證結果**:
  - 成功安裝 `multer`、`@nestjs/serve-static` 及 `@nestjs/platform-express`，後端編譯正常。

紀錄時間：22:47

### Flutter Web 圖片載入錯誤：CORS 編碼拒絕與熱重載失效 (Web: Image Encoding Error & Hot Reload Freeze)
- **問題描述 (Issue)**:
  - 場景：活動詳情頁面渲染多圖時，未能顯示圖片並呈現卡死狀態。
  - 錯誤訊息：`Image load error: http://43.103.3.57:8087/uploads/... - EncodingError: The source image cannot be decoded.` 以及終端機顯示 `Exception: Const class cannot remove fields: ActivityDetailPage`。
- **原因分析**:
  - **CORS 編碼錯誤**：NestJS 的 `ServeStaticModule` 預設不帶跨網域 (CORS) 標頭，導致 Flutter Web 的 `CanvasKit` 引擎基於安全性原則拒絕解碼來自不同端口的靜態圖片。
  - **熱重載失效**：將 `ActivityDetailPage` 將 `Stateless` 改為 `Stateful` 並且具有不同建構子參數時，Flutter Web 的熱重載直接崩潰，使得應用程式畫面停留在舊的狀態（寫死的「洛杉磯」內容）。
- **解決方案 (Solution)**:
  - **後端 CORS 配置**：在 `app.module.ts` 的 `ServeStaticModule.forRoot` 中新增 `serveStaticOptions`，設定 `setHeaders` 強制回應 `Access-Control-Allow-Origin: *`。
  - **應用程式重啟**：重部署後端服務後，於 Flutter Web 開發終端機按 `Shift+R` (Hot Restart) 重置應用程式記憶體，或使用瀏覽器重新整理。
- **驗證結果**:
  - API 成功返回活動正確內容與圖片。
  - 畫面不再停留在洛杉磯卡片，重新載入後可正確渲染並解碼圖片。

紀錄時間：23:14

### 後端圖片上傳：容器重建導致上傳檔案遺失與 HTTP 404 (Docker: Uploaded Files Lost on Recreate)
- **問題描述 (Issue)**:
  - 場景：執行 `docker compose up -d --build --force-recreate` 部署後，原本成功上傳的圖片遇到 `HTTP 404 (Not Found)` 錯誤。
- **原因分析**:
  - **Docker 容器生命週期特性**：NestJS 後端的靜態目錄 (`/app/uploads`) 並沒有被對應到外部磁碟 (Volume)。當容器透過 `--force-recreate` 重新建立時，舊容器內的檔案會隨之銷毀，導致上傳檔案遺失。
- **解決方案 (Solution)**:
  - **新增持久化掛載 (Volume)**：在 `docker/prod/compose.yaml` 中替 `backend` 新增 volume 參照，映射 `tripfun-backend-uploads:/app/uploads`，保護圖片資料不隨容器重置消失。
  - **重新綁定數據**：執行 `docker compose up` 載入含有 Volume 的配置後，重新上傳圖片並透過 API (`PATCH /activities/:id`) 覆寫關聯資料。
- **驗證結果**:
  - `docker ps` 確認容器正常綁定新的 Volume，再次上傳的圖片永久存續，前端順利抓取並渲染成功。

紀錄時間：23:15
