#!/bin/bash

echo "🚀 Starting the Homemade Food Marketplace Application..."

# Step 2: Pull the latest changes for both FE and BE repositories
# Adjust the paths to your local repo locations
# echo "🔄 Pulling latest changes from frontend and backend repos..."
# git -C ../homemade pull
# git -C ../../Java/homemade-api pull

# Stop and remove containers, networks, images, and volumes
echo "🐳 Removing containers, networks, images, and volumes..."
docker-compose down

# Remove all unused containers, networks, images (both dangling and unreferenced), and optionally, volumes
docker system prune -f

#kill ports
#npx kill-port 5433 5432 8080 3000
#sudo lsof -i :5433 5432 8080 3000 8081

# Build, (re)create, start, and attach to containers for a service
echo "🐳 Launching Docker Compose..."
docker-compose up --build

# Step 4: Wait for the services to initialize
echo "⏳ Waiting for services to start..."
sleep 15

# Step 5: Check the status of all running containers
docker ps

echo "✅ All services have been started!"
echo "Frontend: http://localhost:3000"
echo "Backend: http://localhost:8080"
echo "Database: postgresql://localhost:5432 (user: postgres, password: postgres)"