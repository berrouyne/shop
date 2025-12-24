# =========================
# 1️⃣ Build stage
# =========================
FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build || gulp build

# =========================
# 2️⃣ Runtime stage
# =========================
FROM nginx:alpine

RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf

# ✅ Serve Polymer bundle
COPY --from=builder /app/build/esm-bundled /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
