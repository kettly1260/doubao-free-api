# ---- Build Stage ----
FROM node:18-alpine AS builder

WORKDIR /app

# 复制 package.json & 锁文件（包括 package-lock.json）
COPY package.json yarn.lock ./

# 安装全部依赖（含 devDependencies），以便 tsup 可用
RUN yarn install

# 复制全部代码
COPY . .

# 编译项目
RUN yarn build

# ---- Runtime Stage ----
FROM node:18-alpine

WORKDIR /app

# 复制 production 依赖（只拷贝 package.json 和 yarn.lock，然后装生产依赖）
COPY package.json yarn.lock ./
RUN yarn install --production

# 拷贝构建产物
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/public ./public

EXPOSE 8000

ENV NODE_ENV=production

CMD ["node", "dist/index.js"]
