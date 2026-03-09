#!/bin/bash
# =============================================================================
# Stop Script - Data Science Jupyter Environment
# =============================================================================
# Usage: ./script/stop.sh or bash script/stop.sh
# =============================================================================

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Stopping Jupyter container...${NC}"
docker-compose down
echo -e "${GREEN}✓ Container stopped${NC}"
