# Установка базового образа
FROM node:18-alpine AS builder

# Установка рабочей директории
WORKDIR /app

# Копируем package.json и package-lock.json
COPY package*.json ./

# Устанавливаем зависимости
RUN npm install

# Копируем все файлы проекта
COPY . .

# Сборка приложения
RUN npm run build

# Установка минимального образа для выполнения
FROM node:18-alpine AS runner

# Установка рабочей директории
WORKDIR /app

# Копируем сборку и установленные зависимости
COPY --from=builder /app/.output /app/.output
COPY --from=builder /app/node_modules /app/node_modules
COPY --from=builder /app/package*.json ./

# Экспортируем порт для Nuxt.js
EXPOSE 3000

# Запуск приложения
CMD ["node", ".output/server/index.mjs"]
