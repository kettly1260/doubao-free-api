# 构建阶段
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# 运行阶段
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package*.json ./
# 仅安装生产依赖
RUN npm install --omit=dev
# 设置时区（可选，方便查看日志）
ENV TZ=Asia/Shanghai

EXPOSE 8000
CMD ["node", "dist/index.js"]
