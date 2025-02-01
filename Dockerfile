# Etapa 1: Build
FROM node:18-alpine AS build

# Defina o diretório de trabalho
WORKDIR /app

# Instalar o pnpm e configurar o store local no Docker
RUN npm install -g pnpm
RUN pnpm config set store-dir /app/.pnpm-store

# Copie o package.json e o pnpm-lock.yaml
COPY package.json pnpm-lock.yaml ./

# Instale as dependências com pnpm
RUN pnpm install

# Copie todos os arquivos do projeto
COPY . .

# Crie o build do Next.js
RUN pnpm run build

# Etapa 2: Produção
FROM nginx:alpine

# Copie o build do Next.js para o Nginx
COPY --from=build /app/.next /usr/share/nginx/html

# Copie o arquivo de configuração do Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Exponha a porta que o Nginx vai rodar
EXPOSE 80

# Inicie o Nginx
CMD ["nginx", "-g", "daemon off;"]