#!/bin/bash
# Git Daily Push Script - Improved Version
# Supports Conventional Commits format for structured commit messages
# Usage: ./script/daily-push.sh <type> <subject>
# Example: ./script/daily-push.sh "feat" "add new data analysis notebook"
# 
# Types: feat, fix, docs, style, refactor, test, chore, perf, ci, build

# ============================================================================
# CONFIGURATION
# ============================================================================

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Default branch (auto-detect)
DEFAULT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "main")

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

show_banner() {
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}  🚀 Git Daily Push - Structured Commit Workflow${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
}

show_usage() {
    echo -e "${YELLOW}Usage:${NC}"
    echo "  ./script/daily-push.sh <type> <subject> [body]"
    echo ""
    echo -e "${YELLOW}Examples:${NC}"
    echo "  ./script/daily-push.sh feat 'add user authentication module'"
    echo "  ./script/daily-push.sh fix 'resolve memory leak in data loader'"
    echo "  ./script/daily-push.sh docs 'update API documentation'"
    echo "  ./script/daily-push.sh chore 'update dependencies'"
    echo ""
    echo -e "${YELLOW}Available Types:${NC}"
    echo "  feat     - New feature"
    echo "  fix      - Bug fix"
    echo "  docs     - Documentation changes"
    echo "  style    - Code style (formatting, semicolons)"
    echo "  refactor - Code refactoring"
    echo "  test     - Testing changes"
    echo "  chore    - Maintenance tasks"
    echo "  perf     - Performance improvements"
    echo "  ci       - CI/CD changes"
    echo "  build    - Build system changes"
    echo ""
    echo -e "${YELLOW}Quick Modes:${NC}"
    echo "  ./script/daily-push.sh            - Interactive mode"
    echo "  ./script/daily-push.sh wip        - Work in progress commit"
    echo "  ./script/daily-push.sh quick     - Quick save without message"
}

# Interactive mode
interactive_mode() {
    echo -e "${YELLOW}📝 Interactive Commit Mode${NC}"
    echo ""
    
    # Show changed files
    echo -e "${CYAN}Changed files:${NC}"
    git status --short
    echo ""
    
    # Ask for type
    echo -e "${YELLOW}Select commit type:${NC}"
    select type in "feat" "fix" "docs" "style" "refactor" "test" "chore" "perf" "ci" "build" "wip"; do
        case $type in
            wip) 
                TYPE="wip"
                break
                ;;
            *) 
                TYPE=$type
                break
                ;;
        esac
    done
    
    echo ""
    read -p "Enter commit subject: " subject
    echo ""
    read -p "Enter commit body (optional, press Enter to skip): " body
    
    if [ -z "$subject" ]; then
        echo -e "${RED}❌ Error: Commit subject is required${NC}"
        exit 1
    fi
    
    create_commit "$TYPE" "$subject" "$body"
}

# Create commit with conventional format
create_commit() {
    local type=$1
    local subject=$2
    local body=$3
    
    # Format: type(scope): subject
    # For wip: WIP: subject
    if [ "$type" = "wip" ]; then
        COMMIT_MSG="WIP: $subject"
    else
        COMMIT_MSG="$type: $subject"
    fi
    
    # Add body if provided
    if [ -n "$body" ]; then
        COMMIT_MSG="$COMMIT_MSG

$body"
    fi
    
    # Add footer with date
    local date=$(date "+%Y-%m-%d %H:%M %Z")
    COMMIT_MSG="$COMMIT_MSG

Reviewed-on: $date"
    
    echo -e "${YELLOW}📦 Staging all changes...${NC}"
    git add -A
    
    # Check if there are changes
    if git diff --staged --quiet; then
        echo -e "${GREEN}✅ No changes to commit. Working directory is clean.${NC}"
        exit 0
    fi
    
    echo -e "${YELLOW}💾 Committing with message:${NC}"
    echo -e "${CYAN}$COMMIT_MSG${NC}"
    echo ""
    
    git commit -m "$COMMIT_MSG"
    
    # Push to remote
    echo -e "${YELLOW}📤 Pushing to remote...${NC}"
    git push origin $DEFAULT_BRANCH 2>/dev/null || git push origin main 2>/dev/null || git push origin master 2>/dev/null
    
    if [ $? -eq 0 ]; then
        echo ""
        echo -e "${GREEN}✅ Daily push completed successfully!${NC}"
        echo -e "${GREEN}📝 Commit recorded on: $(date '+%Y-%m-%d at %H:%M:%S')${NC}"
        
        # Show recent commits
        echo ""
        echo -e "${CYAN}Recent commits:${NC}"
        git log --oneline -5
    else
        echo -e "${RED}❌ Push failed. Please check your remote configuration.${NC}"
        exit 1
    fi
}

# Quick save - for rapid prototyping
quick_save() {
    echo -e "${YELLOW}⚡ Quick Save Mode${NC}"
    
    # Get list of changed files
    local files=$(git status --short | head -5)
    
    if [ -z "$files" ]; then
        echo -e "${GREEN}✅ No changes to commit.${NC}"
        exit 0
    fi
    
    # Auto-detect type based on changed files
    local type="chore"
    case "$files" in
        *notebook*|*ipynb*) type="feat" ;;
        *test*) type="test" ;;
        *docs*|*md) type="docs" ;;
        *src*|*script*) type="feat" ;;
    esac
    
    local subject="Quick save - $(date '+%Y-%m-%d %H:%M')"
    
    create_commit "$type" "$subject" "Auto-detected changes"
}

# Work in Progress commit
wip_commit() {
    local subject="${1:-WIP: work in progress}"
    create_commit "wip" "$subject" ""
}

# ============================================================================
# MAIN SCRIPT
# ============================================================================

show_banner

# Check if git is initialized
if [ ! -d ".git" ]; then
    echo -e "${RED}❌ Error: Not a git repository${NC}"
    echo -e "${YELLOW}Initializing git repository...${NC}"
    git init
    git add .
    echo -e "${YELLOW}Please configure remote first:${NC}"
    echo "  git remote add origin <your-github-url>"
    exit 1
fi

# Check for uncommitted changes
echo -e "${YELLOW}📊 Checking git status...${NC}"
git status --short
echo ""

# Parse arguments
if [ $# -eq 0 ]; then
    # No arguments - show interactive mode
    interactive_mode
elif [ "$1" = "quick" ]; then
    # Quick save mode
    quick_save
elif [ "$1" = "wip" ]; then
    # Work in progress
    shift
    wip_commit "$*"
elif [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    show_usage
    exit 0
else
    # Conventional commit mode: type subject [body]
    TYPE=$1
    shift
    
    # Validate type
    case "$TYPE" in
        feat|fix|docs|style|refactor|test|chore|perf|ci|build)
            ;;
        *)
            echo -e "${RED}❌ Invalid type: $TYPE${NC}"
            echo -e "${YELLOW}Valid types: feat, fix, docs, style, refactor, test, chore, perf, ci, build${NC}"
            exit 1
            ;;
    esac
    
    # Get subject (remaining args)
    if [ $# -eq 0 ]; then
        echo -e "${RED}❌ Error: Commit subject is required${NC}"
        show_usage
        exit 1
    fi
    
    subject="$*"
    create_commit "$TYPE" "$subject" ""
fi
