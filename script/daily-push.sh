#!/bin/bash
# Git Daily Push Script
# Usage: ./script/daily-push.sh [optional message]
# Example: ./script/daily-push.sh "Update notebook analysis"

# Get current date for commit message
CURRENT_DATE=$(date "+%Y-%m-%d")
CURRENT_TIME=$(date "+%H:%M:%M %Z")

# Default message if no custom message provided
if [ -z "$1" ]; then
    COMMIT_MSG="Daily update - ${CURRENT_DATE}"
else
    COMMIT_MSG="$1 - ${CURRENT_DATE}"
fi

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🚀 Starting daily git push...${NC}"

# Check if git is initialized
if [ ! -d ".git" ]; then
    echo -e "${YELLOW}Initializing git repository...${NC}"
    git init
    git add .
    echo -e "${YELLOW}Please configure remote first:${NC}"
    echo "  git remote add origin <your-github-url>"
    exit 1
fi

# Show status
echo -e "${YELLOW}📊 Checking git status...${NC}"
git status --short

# Add all changes
echo -e "${YELLOW}📦 Staging all changes...${NC}"
git add -A

# Check if there are changes to commit
if git diff --staged --quiet; then
    echo -e "${GREEN}✅ No changes to commit. Working directory is clean.${NC}"
    exit 0
fi

# Commit with clear message
echo -e "${YELLOW}💾 Committing with message: ${COMMIT_MSG}${NC}"
git commit -m "${COMMIT_MSG}"

# Push to remote
echo -e "${YELLOW}📤 Pushing to remote...${NC}"
git push origin main 2>/dev/null || git push origin master 2>/dev/null

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Daily push completed successfully!${NC}"
    echo -e "${GREEN}📝 Commit recorded on: ${CURRENT_DATE} at ${CURRENT_TIME}${NC}"
else
    echo -e "${YELLOW}⚠️  Push failed. Please check your remote configuration.${NC}"
    exit 1
fi
