#!/bin/bash
set -euxo pipefail

# Install dependencies
apt-get update -y
apt-get install -y docker.io git

# Start Docker
systemctl enable docker
systemctl start docker

# Allow ubuntu user to use Docker
usermod -aG docker ubuntu

APP_DIR="/home/ubuntu/Pankeki-Express"

# Clone repo and checkout dev branch
su - ubuntu -c "
  git clone ${repo_url} $APP_DIR
  cd $APP_DIR
  git checkout ${branch}
"

# Build and run backend container
su - ubuntu -c "
  cd $APP_DIR/backend

  docker build -t pankeki-backend .

  docker run -d \
    --name backend \
    --env-file $APP_DIR/backend/.env \
    -p 1323:1323 \
    pankeki-backend
"