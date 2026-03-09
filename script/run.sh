#!/bin/bash
# =============================================================================
# Run Script - Data Science Jupyter Environment
# =============================================================================
# Usage: ./script/run.sh or bash script/run.sh
# =============================================================================

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Data Science Jupyter Environment${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Check if Docker is running
echo -e "${YELLOW}Checking Docker...${NC}"
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed${NC}"
    exit 1
fi

if ! docker info &> /dev/null; then
    echo -e "${RED}Error: Docker is not running${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Docker is running${NC}"
echo ""

# Check if .env file exists
if [ ! -f "docker/.env" ]; then
    echo -e "${YELLOW}Creating .env file from example...${NC}"
    cp docker/.env.example docker/.env
    echo -e "${YELLOW}Please edit docker/.env with your JUPYTER_TOKEN${NC}"
    echo ""
fi

# Pull latest image
echo -e "${YELLOW}Pulling latest image...${NC}"
cd docker
docker-compose pull
echo ""

# Build container
echo -e "${YELLOW}Building container...${NC}"
docker-compose build
echo ""

# Start container
echo -e "${YELLOW}Starting container...${NC}"
docker-compose up -d
echo ""

# Wait for container to start
echo -e "${YELLOW}Waiting for JupyterLab to start...${NC}"
sleep 5

# Get token from .env
TOKEN=$(grep JUPYTER_TOKEN docker/.env | cut -d '=' -f2)

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Container Started Successfully!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "JupyterLab URL: ${GREEN}http://localhost:8889${NC}"
echo -e "Token: ${GREEN}$TOKEN${NC}"
echo ""
echo -e "${YELLOW}Useful commands:${NC}"
echo -e "  View logs:  ${GREEN}docker-compose logs -f${NC}"
echo -e "  Stop:      ${GREEN}docker-compose down${NC}"
echo -e "  Restart:   ${GREEN}docker-compose restart${NC}"
echo ""
