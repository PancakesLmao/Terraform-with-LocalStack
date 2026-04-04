#!/bin/bash
set -euxo pipefail

# Install dependencies
apt-get update -y
apt-get install -y docker.io git

# Start Docker (no systemd in LocalStack's Docker-backed EC2)
# Use dockerd directly instead of systemctl
if command -v systemctl &>/dev/null && systemctl is-system-running &>/dev/null; then
  systemctl enable docker
  systemctl start docker
else
  # LocalStack / container environment: start dockerd in background
  nohup dockerd --host=unix:///var/run/docker.sock &>/var/log/dockerd.log &
  # Wait until the socket is ready
  timeout 30 sh -c 'until docker info &>/dev/null; do sleep 1; done'
fi

# Allow ubuntu user to use Docker
usermod -aG docker ubuntu

APP_DIR="/home/ubuntu/Pankeki-Express"

# Clone repo and checkout branch
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