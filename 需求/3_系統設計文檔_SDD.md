---

## 11. 規劃完整詳細目錄結構 (Detailed Planned Directory Structure)

```text
TripFun/
├── .agent/                      # AI 代理指令、工作流範本
├── .cursor/                     # Cursor 專案規則 (.mdc)
├── backend/                     # 後端 NestJS 核心 (API)
│   ├── docker/                  # Backend Dockerfiles
│   │   ├── local/Dockerfile     # 本地開發 (含 pnpm, Hot Reload)
│   │   └── prod/Dockerfile      # 生產構建 (Multi-stage)
│   ├── src/
│   │   ├── main.ts              # 入口文件
│   │   ├── app.module.ts        # 根模組
│   │   ├── common/              # 全域通用組件
│   │   │   ├── decorators/      # 自定義裝飾器 (如 @CurrentUser)
│   │   │   ├── filters/         # 異常過濾器 (HttpExceptionFilter)
│   │   │   ├── guards/          # 權限守衛 (AuthGuard, RolesGuard)
│   │   │   ├── interceptors/    # 攔截器 (TransformInterceptor)
│   │   │   └── pipes/           # 校驗管道 (ValidationPipe)
│   │   ├── config/              # 配置模組 (env, redis, postgres)
│   │   ├── database/            # 資料庫相關
│   │   │   ├── migrations/      # 遷移文件 (YYYYMMDDHHmmss-Name.ts)
│   │   │   ├── seeders/         # 初始數據填充
│   │   │   └── base.entity.ts   # 通用基礎 Entity (id, created_at...)
│   │   └── modules/             # 業務功能模組 (組件化)
│   │       ├── auth/            # 認證授權模組
│   │       │   ├── controllers/
│   │       │   ├── services/
│   │       │   ├── dto/         # Request 驗證模型
│   │       │   ├── entities/    # 資料表模型
│   │       │   ├── strategies/  # Passport 策略 (JWT)
│   │       │   └── auth.module.ts
│   │       ├── trips/           # 行程管理模組
│   │       ├── chat-sync/       # 與 Go 服務同步的對接模組
│   │       └── ...
│   ├── test/                    # 測試目錄 (unit, e2e)
│   ├── package.json             # 強制使用 pnpm
│   └── tsconfig.json
├── chat/                        # 高併發即時通訊 (Go)
│   ├── api/                     # API 定義 (Proto/Swagger)
│   ├── cmd/
│   │   └── server/              # 服務啟動入口 (main.go)
│   ├── configs/                 # YAML 配置文件
│   ├── docker/                  # Go Dockerfiles (local/prod)
│   ├── internal/                # 內部業務邏輯 (不可被外部引用)
│   │   ├── delivery/            # 傳輸層 (WebSocket Handlers, HTTP)
│   │   ├── service/             # 業務邏輯 (IM Logic, Pub/Sub)
│   │   ├── repository/          # 數據存取 (Redis/Postgres)
│   │   └── model/               # 數據結構定義
│   ├── pkg/                     # 通用工具庫 (Logger, RedisPool)
│   └── go.mod
├── mobile/                      # 行動端 (Flutter Mobile App)
│   ├── lib/
│   │   ├── main.dart            # 入口
│   │   ├── core/                # 全域核心層
│   │   │   ├── constants/       # 顏色、字體、API Endpoints
│   │   │   ├── error/           # 異常處理機制
│   │   │   ├── theme/           # 主題規範 (Material 3)
│   │   │   └── utils/           # 工具類 (Date, Timezone)
│   │   ├── data/                # 數據層 (Data Layer)
│   │   │   ├── data_sources/    # 遠端 (Dio) / 本地 (SQLite) 來源
│   │   │   ├── dtos/            # 從 API 拿到的原始 JSON 模型
│   │   │   └── repositories/    # Repository 實作
│   │   ├── domain/              # 領域層 (Domain Layer)
│   │   │   ├── entities/        # 核心業務模型
│   │   │   ├── repositories/    # Repository 介面定義
│   │   │   └── usecases/        # 業務場景邏輯
│   │   └── presentation/        # UI 層 (Presentation Layer)
│   │       ├── global_widgets/  # 全域通用組件 (Button, Card)
│   │       ├── providers/       # 全域狀態管理 (Riverpod/Provider)
│   │       └── pages/           # 頁面視圖
│   │           ├── home/
│   │           │   ├── pages/
│   │           │   ├── widgets/
│   │           │   └── provider/
│   │           └── ...
│   ├── assets/                  # 靜態資源 (Images, Fonts, I18n)
│   ├── test/                    # 容器內運行的測試
│   └── pubspec.yaml
├── docker/                      # 全域容器編排
│   ├── local/
│   │   ├── compose.yaml         # 本地開發 (含 Hot Reload 映射)
│   │   └── nginx.conf           # 轉發 9001, 9002 端口
│   └── prod/
│       └── compose.yaml         # 生產環境配置
├── env/                         # 環境變數管理 (Git 忽略敏感內容)
├── devlog/                      # 開發日誌與 SOP
└── 需求/                        # 設計與規劃文檔
```

---

## 1. 系統架構概要 (System Architecture)

### 1.1 技術棧 (Tech Stack)
*   **後端 (Backend)**: NestJS (Node.js 框架)
*   **資料庫 (Database)**: PostgreSQL (主資料庫) + Redis (緩存與即時數據)
*   **行動端 (App)**: Flutter (iOS/Android)
*   **容器化 (DevOps)**: Docker + Docker Compose (使用多階段構建)

### 1.2 後端代碼分層 (Backend Layering - NestJS)
*   **Controller 層**: 僅處理 Request/Response 格式，不涉及業務邏輯。
*   **Service 層**: 核心業務邏輯所在地，跨模組調用需透過 Service 注入。
*   **Repository/DAO 層**: 負責資料庫交互，保持原子性。
*   **Entities/DTOs**: 強類型定義，禁止使用 `any`。

### 1.3 行動端代碼分層 (Mobile Layering - Mobile App)
採用 **Clean Architecture** 概念之組件化分層：
*   **Presentation Layer (UI 層)**:
    - `widgets/`: 最小單位原子組件 (Atomic Components)。
    - `pages/`: 完整畫面視圖。
    - `providers/view_models/`: 管理 UI 狀態與處理簡單交互邏輯。
*   **Domain Layer (領域層)**:
    - `entities/`: 核心業務模型。
    - `usecases/`: 定義業務功能的抽象介面。
*   **Data Layer (數據層)**:
    - `repositories/`: 實現領域層介面，處理數據流向（API 或 Cache）。
    - `data_sources/`: 具體的 API Client (Dio) 或 Local DB 實作。
    - `dtos/`: 數據傳輸對象與 JSON 序列化邏輯。

---

## 2. 容器化與環境規範 (Container & Environment)

### 2.1 命名規範 (Naming)
*   **專案容器組 (Project Name)**: `tripfun` (透過 `docker-compose -p tripfun` 指定)
*   **容器名稱前綴**: `tripfun-` (例: `tripfun-backend`, `tripfun-db`, `tripfun-redis`)

### 2.2 環境配置 (Environment Separation)
*   **本地環境 (`local`)**: 
    - 配置路徑: `env/local/.env`, `docker/local/compose.yaml`
    - 功能: 開啟熱重載 (Hot Reload)、映射原始碼。
*   **生產環境 (`prod`)**: 
    - 配置路徑: `env/prod/.env`, `docker/prod/compose.yaml`
    - 功能: 採用多階段構建 (Multi-stage Build)，僅保留執行所需的 Runtime。

### 2.3 Docker 構建策略 (Multi-stage Build)
```dockerfile
# Backend 範例
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN pnpm install
COPY . .
RUN pnpm run build

FROM node:20-alpine AS runner
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
CMD ["node", "dist/main"]
```

### 2.4 健康檢查規範 (Health Check)
所有容器必須配置 `healthcheck`，確保服務不穩定時能被系統偵測：
*   **Backend (NestJS)**: 需實作並檢查 `GET /api/v1/health`。
*   **Chat Service (Go)**: 需實作並檢查 `GET /health`。
*   **PostgreSQL**: 使用官方指令 `pg_isready -U ${DB_USER} -d ${DB_NAME}`。
*   **Redis**: 使用官方指令 `redis-cli ping`。

---

## 3.資料庫設計規範 (Database Schema)

### 3.1 核心表結構 (Tables Dictionary)

| 表名稱 | 物理名稱 | 作用說明 | 關鍵欄位 |
| :--- | :--- | :--- | :--- |
| **用戶表** | `users` | 存儲 App 用戶基礎資訊。 | `phone`, `email`, `nickname`, `avatar` |
| **行程表** | `trips` | 行程主體，定義目的與起訖日。 | `name`, `share_token`, `start_date`, `end_date` |
| **成員表** | `trip_members` | 處理家屬協作與權限分配。 | `trip_id`, `user_id`, `role` (OWNER, VIEWER) |
| **活動表** | `activities` | 記錄時間軸上的每一筆細節。 | `trip_id`, `title`, `start_time`, `content`, `type` |
| **預訂庫** | `booking_vault` | 存放機票、住宿等憑證資訊。 | `type` (FLIGHT, HOTEL), `booking_ref`, `attachments` |
| **記帳表** | `expenses` | 記錄旅途開銷。 | `amount`, `currency`, `category`, `exchange_rate` |
| **百科表** | `travel_tips` | 存放各國預設建議與用戶筆記。 | `country_code`, `category`, `content` |

### 3.2 時間與遷移規範
*   **時間策略**: 存儲一律使用 `TIMESTAMP WITHOUT TIME ZONE` 並預設為 UTC。
*   **遷移規範**: 詳見 3.2 節 (原定)。
*   **命名格式**: `YYYYMMDDHHmmss-Description.ts`。
*   **規則**: 嚴禁手動修改資料庫 Schema，所有變動必須透過遷移文件執行。

---

## 4. 前端 Flutter 開發規範 (Flutter Standards)

### 4.1 組件化設計 (Componentization)
*   **原子組件**: 按鈕、輸入框、卡片等抽離至 `lib/components`。
*   **狀態管理**: 採用 Provider 或 Riverpod 進行狀態與 UI 分離。
*   **邏輯解耦**: 所有的 API 調用封裝在 `repositories` 層，禁止在 UI 目錄直接寫邏輯。

---

## 5. 代碼註釋與命名標準 (Coding Standards)

### 5.1 文件頭部註釋 (Header Comments)
所有代碼文件開頭必須包含中英文雙語註釋：
```typescript
/**
 * @file TripService.ts
 * @description 行程核心邏輯處理服務 / Trip core logic processing service
 * @description_zh 負責行程的建立、更新、權限校驗與成員關聯
 * @description_en Handles trip creation, updating, permission validation, and member association
 */
```

### 5.2 功能模塊註釋 (Module Comments)
```typescript
// ========================================
// 權限檢查邏輯 / Permission Check Logic
// ========================================
async checkPermission(userId: string, tripId: string) { ... }
```

### 5.4 套件管理規範 (Package Management)
*   **後端**: 一律強制使用 **pnpm**，嚴禁使用 npm 或 yarn。這有助於節省磁碟空間並提高依賴安裝速度。
*   **前端 (Mobile)**: 使用 Flutter 標準的 `pub` 管理。

---

## 6. API 與實時通信規範 (API & Real-time)

### 6.1 測試執行規範 (Testing Policy)
為了確保測試結果在不同環境下的一致性：
*   **環境強制**: 所有單元測試 (Unit Test) 與集成測試 (E2E) **必須在 Docker 容器內部執行**。
*   **執行範例**: `docker exec -it tripfun-backend pnpm test`。
*   **本地依賴**: 開發者不應依賴本地安裝的 Node.js 運行測試，一切以容器環境為準。

### 6.2 實時同步架構 (Real-time Sync)
為了實現多人協作不刷新更新，採用 **Socket.io**：
*   **房間機制**: 每個行程 (`trip_id`) 對應一個獨立的 Socket Room。
*   **交互流程**:
    1. 用戶 A 變更資料 -> 透過 RESTful API 送至後端。
    2. 後端更新 DB -> 觸發 `EventEmitter`。
    3. Socket Gateway 捕捉事件 -> 對該 `trip_id` 房間推送 `DATA_UPDATED` 訊息。
    4. 用戶 B (App) 監聽到訊息 -> 靜默觸發數據刷新邏輯，UI 自動更新。

---

## 7. 多國語言與國際化 (i18n)

### 7.1 支持語系
*   預設支持：繁體中文 (zh-TW)、英文 (en-US)、日文 (ja-JP)。

### 7.2 實作規範
*   **前端 (Flutter)**: 使用 `flutter_localizations` 配合 `.arb` 資源文件。所有硬編碼文字必須透過 `context.l10n.text` 調用。
*   **後端 (NestJS)**: 使用核心 `I18nModule`，根據 Request Header 中的 `Accept-Language` 返回對應語系的錯誤訊息或系統通知。

---

## 8. 安全文件存儲與加密 (Storage & Security)

### 8.1 敏感資料存儲 (Passport/Tickets)
*   **存儲位置**: 文件不存於資料庫，而是存放於磁碟掛載路徑 (`/uploads`) 或雲端 Storage。
*   **安全訪問**: 
    - 檔案夾禁止直接 Web 訪問。
    - 訪問時需透過後端授權，生成帶簽名的臨時 URL (Signed URL / Blob URL)。
*   **圖片加密**: 存儲至硬碟前可進行 AES 加密，防止磁碟內容外洩。

### 8.2 安全規範
*   **認證**: 使用 JWT (Bearer Token)，Secret 存放於環境變數。
*   **密碼**: 採用 **Argon2** 進行加鹽雜湊。
*   **頻率限制**: 針對登入與分享連結 API 設定 Rate Limiting。

---

## 9. 深度連結實作 (Deep Linking)

### 9.1 機制說明
*   使用 **UUID 共享連結**：`https://tripfun.app/join?token={uuid}`。
*   **App 攔截**:
    - Android:意圖過濾器 (Intent Filter)。
    - iOS: 通用連結 (Universal Links)。
*   **處理流程**: 
    1. App 捕捉到 URL。
    2. 解析 Token。
    3. 自動跳轉至「行程加入確認頁面」。

---

## 10. 日誌規範 (Logging Convention)

### 6.1 分級日誌
*   **DEBUG**: 用於開發環境追蹤變數狀態。
*   **INFO**: 記錄關鍵業務節點（如：用戶加入行程、生成邀請連結）。
*   **WARN**: 異常但非致命錯誤（如：API 頻繁請求）。
*   **ERROR**: 系統崩潰或資料庫異常，需包含詳盡的 Stack Trace。

---

## 7. 數據模型 (Initial Data Models)

### 7.1 trips (行程表)
* `id`: UUID (PK)
* `name`: VARCHAR(100)
* `share_token`: UUID (唯一邀請連結)
* `owner_id`: UUID (FK)
* `start_date`: TIMESTAMP (UTC)
* `end_date`: TIMESTAMP (UTC)

### 7.2 trip_members (行程成員關聯表)
* `trip_id`: UUID (FK)
* `user_id`: UUID (FK)
* `role`: VARCHAR(20) (OWNER, MANAGER, VIEWER)
* `joined_at`: TIMESTAMP (UTC)

---

## 8. 性能最優化策略 (Optimization)
1. **Redis 緩存**: 針對讀取頻率極高的「今日行程」與「地圖座標」進行 Redis 緩存。
2. **多階段構建**: 最小化 Production Image 體積。
3. **資料庫索引**: 針對 `share_token` 與 `trip_id` 建立複合索引。

---

## 12. 端口分配規範 (Port Allocation)

為了避免與本地現有容器 (如 5006, 8082 等) 衝突，TripFun 專案統一使用 **9000-9999** 區間：

| 服務名稱 | 容器內端口 | 本地映射端口 (Host) | 備註 |
| :--- | :--- | :--- | :--- |
| **Backend (NestJS)** | 3000 | **9001** | 核心業務 API |
| **Chat Service (Go)** | 8080 | **9002** | 高併發即時通訊 |
| **PostgreSQL** | 5432 | **9432** | 資料庫 |
| **Redis** | 6379 | **9379** | 緩存與 Socket 共享 |

---

## 13. 高併發即時通訊設計 (Go Chat Service)

### 13.1 職責定義
*   **NestJS**: 負責獲取完整對話紀錄 (History) 與用戶權限驗證。
*   **Chat Service (Go)**: 專注於 **WebSocket 長連接維護**、**即時消息推送** 與 **圖片二進制流分發**。

### 13.2 技術選型
*   **Framework**: Gin 或 Fiber (輕量級高效能)。
*   **WebSocket**: `gorilla/websocket`。
*   **Pub/Sub**: 使用 **Redis Pub/Sub** 實現跨多個 Go 實例的消息廣播。

### 13.3 圖片處理邏輯
*   App 透過 NestJS API 上傳圖片獲取 URL。
*   Go Service 透過 WebSocket 推送圖片消息（含縮略圖數據與完整 URL）。
