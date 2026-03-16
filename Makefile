# Makefile - Data Science Jupyter Environment
# Usage: make <target>

# Default target
.DEFAULT_GOAL := help

# Colors
BOLD := \033[1m
GREEN := \033[0;32m
YELLOW := \033[0;33m
RED := \033[0;31m
NC := \033[0m # No Color

# =============================================================================
# Git Commands
daily-push:
	@echo "🚀 Running daily git push..."
	@bash script/daily-push.sh

daily-push-msg:
	@echo "🚀 Running daily git push with custom message..."
	@bash script/daily-push.sh "$(MSG)"

git-status:
	git status

git-log:
	git log --oneline -10

# Docker Commands
# =============================================================================

.PHONY: up down restart logs logs-follow build rebuild clean help

# Start container
up:
	@echo "$(GREEN)Starting Jupyter container...$(NC)"
	docker-compose up -d
	@echo "$(GREEN)JupyterLab available at: http://localhost:8889$(NC)"
	@echo "$(GREEN)Token: Check docker/.env file$(NC)"

# Stop container
down:
	@echo "$(YELLOW)Stopping Jupyter container...$(NC)"
	docker-compose down

# Restart container
restart:
	@echo "$(YELLOW)Restarting Jupyter container...$(NC)"
	docker-compose restart

# View logs
logs:
	docker-compose logs --tail=100

# Follow logs
logs-follow:
	docker-compose logs -f

# Build container
build:
	@echo "$(GREEN)Building container...$(NC)"
	docker-compose build --no-cache

# Rebuild container (pull latest image)
rebuild:
	@echo "$(GREEN)Rebuilding container with latest image...$(NC)"
	docker-compose pull
	docker-compose up -d --build

# Clean up
clean:
	@echo "$(RED)WARNING: This will remove all containers and volumes!$(NC)"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		cd docker && docker-compose down -v; \
		echo "$(GREEN)Cleanup complete.$(NC)"; \
	else \
		echo "$(YELLOW)Aborted.$(NC)"; \
	fi

# =============================================================================
# Development Commands
# =============================================================================

.PHONY: shell shell-root install-deps update-deps

# Access container shell
shell:
	docker exec -it jupyter_datascience bash

# Access container as root
shell-root:
	docker exec -it -u root jupyter_datascience bash

# Install dependencies
install-deps:
	@echo "$(GREEN)Installing dependencies...$(NC)"
	docker exec jupyter_datascience bash -c "source /opt/conda/etc/profile.d/conda.sh && conda activate base && conda install -y numpy pandas matplotlib scikit-learn"

# Update dependencies
update-deps:
	@echo "$(GREEN)Updating all packages...$(NC)"
	docker exec jupyter_datascience bash -c "source /opt/conda/etc/profile.d/conda.sh && conda activate base && conda update --all"

# =============================================================================
# Data Commands
# =============================================================================

.PHONY: backup restore clean-data

# Backup data
backup:
	@echo "$(GREEN)Creating backup...$(NC)"
	mkdir -p backups
	tar -czvf backups/backup-$$(date +%Y%m%d-%H%M%S).tar.gz \
		notebooks/ data/ models/ logs/ 2>/dev/null || true
	@echo "$(GREEN)Backup created in backups/$(NC)"

# Restore from backup
restore:
	@echo "$(YELLOW)Available backups:$(NC)"
	@ls -lh backups/
	@read -p "Enter backup filename: " backupfile; \
	tar -xzvf backups/$$backupfile

# Clean data
clean-data:
	@echo "$(YELLOW)WARNING: This will remove all data files!$(NC)"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		find data/ -type f -exec rm -f {} \; 2>/dev/null || true; \
		find notebooks/ -name "*.ipynb" -exec rm -f {} \; 2>/dev/null || true; \
		echo "$(GREEN)Data cleaned.$(NC)"; \
	else \
		echo "$(YELLOW)Aborted.$(NC)"; \
	fi

# =============================================================================
# Monitoring Commands
# =============================================================================

.PHONY: status stats

# Check container status
status:
	@echo "$(GREEN)Container Status:$(NC)"
	@docker ps -a | grep jupyter || echo "No container found"
	@echo ""
	@echo "$(GREEN)Container Health:$(NC)"
	@docker inspect --format='{{.State.Health.Status}}' jupyter_datascience 2>/dev/null || echo "N/A"

# Check resource usage
stats:
	@docker stats jupyter_datascience --no-stream

# =============================================================================
# Help
# =============================================================================

help:
	@echo "$(BOLD)Data Science Jupyter Environment - Makefile$(NC)"
	@echo ""
	@echo "$(BOLD)Docker Commands:$(NC)"
	@echo "  make up           - Start container"
	@echo "  make down         - Stop container"
	@echo "  make restart      - Restart container"
	@echo "  make logs         - View logs"
	@echo "  make logs-follow  - Follow logs"
	@echo "  make build        - Build container"
	@echo "  make rebuild      - Rebuild with latest image"
	@echo "  make clean        - Remove container and volumes"
	@echo ""
	@echo "$(BOLD)Development:$(NC)"
	@echo "  make shell        - Access container shell"
	@echo "  make shell-root   - Access as root"
	@echo "  make install-deps - Install dependencies"
	@echo "  make update-deps  - Update dependencies"
	@echo ""
	@echo "$(BOLD)Data:$(NC)"
	@echo "  make backup       - Backup all data"
	@echo "  make restore      - Restore from backup"
	@echo "  make clean-data   - Clean data files"
	@echo ""
	@echo "$(BOLD)Monitoring:$(NC)"
	@echo "  make status       - Check container status"
	@echo "  make stats       - Check resource usage"
	@echo ""
	@echo "$(BOLD)Other:$(NC)"
	@echo "  make help         - Show this help"