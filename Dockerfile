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

# Build Polymer app
RUN npm run build || gulp build

# =========================
# 2️⃣ Runtime stage
# =========================
FROM nginx:alpine

# Remove default nginx default config
RUN rm /etc/nginx/conf.d/default.conf

# Custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy Polymer build output
COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
