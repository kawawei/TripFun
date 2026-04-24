# ================================================================
# @file Dockerfile (prod)
# @description 後端生產環境多階段構建 / Backend production multi-stage build
# @description_zh 使用 pnpm 安裝依賴並編譯 TypeScript，僅保留生產所需的 Runtime 產物
# @description_en Build NestJS with pnpm and copy only production artifacts to runner
# ================================================================

# ------------------------------------------------
# Stage 1: Builder - 安裝依賴並編譯 / Install deps & compile
# ------------------------------------------------
FROM node:20-alpine AS builder

WORKDIR /app

# 安裝 pnpm / Install pnpm
RUN npm install -g pnpm

# 複製依賴管理文件 / Copy dependency files
COPY package.json pnpm-lock.yaml* ./

# 安裝所有依賴（含開發依賴，用於編譯）/ Install all deps including devDependencies for build
RUN pnpm install --frozen-lockfile

# 複製源碼 / Copy source code
COPY src ./src
COPY tsconfig.json ./

# 編譯 TypeScript / Compile TypeScript
RUN pnpm exec nest build

# ------------------------------------------------
# Stage 2: Runner - 最小化 Runtime / Minimal runtime
# ------------------------------------------------
FROM node:20-alpine AS runner

WORKDIR /app

# 安裝 pnpm / Install pnpm
RUN npm install -g pnpm

# 複製依賴管理文件並只安裝生產依賴 / Copy and install production dependencies only
COPY package.json pnpm-lock.yaml* ./
RUN pnpm install --frozen-lockfile --prod

# 從 builder 複製編譯產物 / Copy compiled output from builder
COPY --from=builder /app/dist ./dist

# 開放端口 / Expose port
EXPOSE 3000

# 啟動命令 / Start command
CMD ["node", "dist/main"]
