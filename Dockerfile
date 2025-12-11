# --- Builder Stage ---
FROM node:18-alpine AS builder

WORKDIR /app

# 复制 package.json 和 lock 文件
COPY package.json yarn.lock ./

# 安装全部依赖（包括 devDependencies）
RUN yarn install

# 复制项目
COPY . .

# 编译项目
RUN yarn build

# --- Runtime Stage ---
FROM node:18-alpine

WORKDIR /app

# 复制 package.json 和 lock 文件
COPY package.json yarn.lock ./

# 安装生产依赖
RUN yarn install --production

# 复制构建产物
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/public ./public

# 明确暴露应用监听端口
EXPOSE 8000

ENV NODE_ENV=production
ENV PORT=8000

# 启动命令
CMD ["node", "dist/index.js"]
