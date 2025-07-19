# Makefile pour le projet Inception

# Variables
COMPOSE_FILE = srcs/docker-compose.yml
ENV_FILE = srcs/.env
DATA_PATH = /home/$(USER)/data
VOLUMES = database website

# Couleurs pour l'affichage
GREEN = \033[0;32m
YELLOW = \033[1;33m
RED = \033[0;31m
NC = \033[0m # No Color

.PHONY: all build up down clean fclean re logs ps status help test

# Règle par défaut
all: build up

# Construire les images Docker
build:
	@echo "$(YELLOW)Construction des images Docker...$(NC)"
	@if [ ! -f $(ENV_FILE) ]; then \
		echo "$(RED)Erreur: Fichier .env manquant. Copiez .env.example vers .env$(NC)"; \
		exit 1; \
	fi
	@docker-compose -f $(COMPOSE_FILE) build --no-cache
	@echo "$(GREEN)Images construites avec succès!$(NC)"

# Démarrer les conteneurs
up: 
	@echo "$(YELLOW)Démarrage des conteneurs...$(NC)"
	@docker-compose -f $(COMPOSE_FILE) up -d
	@echo "$(GREEN)Conteneurs démarrés!$(NC)"
	@echo "$(GREEN)Site accessible sur: https://localhost$(NC)"

# Arrêter les conteneurs
down:
	@echo "$(YELLOW)Arrêt des conteneurs...$(NC)"
	@docker-compose -f $(COMPOSE_FILE) down
	@echo "$(GREEN)Conteneurs arrêtés!$(NC)"

# Redémarrer les conteneurs
restart: down up

# Afficher les logs
logs:
	@docker-compose -f $(COMPOSE_FILE) logs -f

# Afficher le statut détaillé
status:
	@echo "$(YELLOW)Statut des conteneurs:$(NC)"
	@docker-compose -f $(COMPOSE_FILE) ps
	@echo "\n$(YELLOW)Utilisation des volumes:$(NC)"
	@docker volume ls | grep wp || echo "Aucun volume trouvé"
	@echo "\n$(YELLOW)Utilisation des réseaux:$(NC)"
	@docker network ls | grep inception || echo "Aucun réseau trouvé"

# Nettoyer les conteneurs et volumes
clean:
	@echo "$(YELLOW)Nettoyage des conteneurs...$(NC)"
	@docker-compose -f $(COMPOSE_FILE) down -v
	@docker system prune -f
	@echo "$(GREEN)Nettoyage terminé!$(NC)"

# Nettoyage complet (conteneurs, volumes, images, données)
fclean: clean
	@echo "$(YELLOW)Nettoyage complet...$(NC)"
	@docker-compose -f $(COMPOSE_FILE) down -v --rmi all
	@docker volume prune -f
	@docker network prune -f
	@if [ -d $(DATA_PATH) ]; then \
		echo "$(YELLOW)Suppression des données dans $(DATA_PATH)...$(NC)"; \
		sudo rm -rf $(DATA_PATH)/database/* 2>/dev/null || true; \
		sudo rm -rf $(DATA_PATH)/website/* 2>/dev/null || true; \
	fi
	@echo "$(GREEN)Nettoyage complet terminé!$(NC)"

# Reconstruire complètement le projet
re: fclean all