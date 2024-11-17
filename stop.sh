#!/bin/bash

echo "🚀 Stopping the Homemade Application..."

# Stop and remove containers, networks, images, and volumes
echo "🐳 Removing containers, networks, images, and volumes..."
docker-compose down

# Remove all unused containers, networks, images (both dangling and unreferenced), and optionally, volumes
docker system prune -f