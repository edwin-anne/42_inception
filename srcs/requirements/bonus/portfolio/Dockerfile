#######################################
# Étape 1 : Build de l’application
#######################################
FROM node:18-alpine AS builder

# 1. Dossier de travail
WORKDIR /app

# 2. Installation des dépendances
COPY package*.json ./
RUN npm install --no-audit

# 3. Copie du code puis build
COPY . .
RUN npm run build

#######################################
# Étape 2 : Conteneur runtime ultra-léger
#######################################
FROM nginx:1.25-alpine

# 4. Copie du build statique dans Nginx
COPY --from=builder /app/dist /usr/share/nginx/html

# 5. Exposition du port 80
EXPOSE 80

# 6. Lancement de Nginx au premier plan
CMD ["nginx", "-g", "daemon off;"]