# ---- Build Stage ----
FROM node:18-alpine AS builder
WORKDIR /app

# 安装依赖
COPY package*.json yarn.lock ./
RUN yarn install --production

# 复制项目文件并构建
COPY . .
RUN yarn build

# ---- Runtime Stage ----
FROM node:18-alpine
WORKDIR /app

# 复制构建产物 & 运行时依赖
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules

EXPOSE 8000
ENV NODE_ENV=production

# 启动服务
CMD ["node", "dist/index.js"]
