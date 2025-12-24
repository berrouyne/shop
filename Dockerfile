# =========================
# 1️⃣ Build stage
# =========================
FROM node:18-alpine AS builder

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy source code
COPY . .

# Build the frontend
# Adjust if your build command is different
RUN npm run build || gulp build

# =========================
# 2️⃣ Runtime stage
# =========================
FROM nginx:alpine

# Remove default nginx config
RUN rm /etc/nginx/conf.d/default.conf

# Custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy built static files
# ⚠️ Adjust "dist" if your output folder differs
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
