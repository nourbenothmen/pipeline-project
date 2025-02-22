FROM node:12.7-alpine AS build

# Définition du répertoire de travail
WORKDIR /usr/src/app

# Copie des fichiers package.json et package-lock.json
COPY package.json package-lock.json ./

# Installation des dépendances
RUN npm install

# Copie de l'ensemble du projet
COPY . .

# Construction de l'application Angular
RUN npm run build

# STAGE 2: Run
FROM nginx:1.17.1-alpine

# Copie du fichier de configuration Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Copie des fichiers construits depuis le stage "build" vers le répertoire de Nginx
COPY --from=build /usr/src/app/dist/aston-villa-app /usr/share/nginx/html
