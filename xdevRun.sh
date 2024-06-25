#!/usr/bin/env bash

# docker rmi -f $(docker images -a -q)
set -e
# Define variables
DOCKER_USR='username'
DOCKER_REPO='hum-admin-gql'
TAG_DATE=$(date +'%d%m%y.%H%M%S')
DFILE='Dockerfile'
CurreBN='admin-init-v1'

# ANSI color codes
CYN='\033[0;36m'
YLW='\033[0;33m'
BLE='\033[0;35m'
GRN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "start"

# Remove package-lock.json if it exists
if [ -f 'package-lock.json' ]; then
  rm 'package-lock.json'
  echo "[+] package-lock.json is removed"
else
  echo "not have file <package-lock.json>"
fi

# # Remove node_modules directory if it exists
# if [ -d 'node_modules' ]; then
#   rm -rf 'node_modules'
#   echo "[+] node_modules is removed"
# else
#   echo "not have file <node_modules>"
# fi

# Append to 'xrun' file
echo "# ${DOCKER_USR}/${DOCKER_REPO}:${TAG_DATE}" >> xprodRun

# Prompt for Git push
read -p "Git push? (Y/N): " confirm
if [[ "$confirm" == "Y" || "$confirm" == "y" ]]; then
  GBRANCH=$(git rev-parse --abbrev-ref HEAD)
  if [[ "$GBRANCH" == "$CurreBN" ]]; then
    echo "Current git branch is $GBRANCH"
    read -p "Enter git comment: " gitComment
    git add .
    git commit -am "$gitComment at $(date)"
    if git push --set-upstream origin "$GBRANCH"; then
      echo "Git push was successful for $GBRANCH"
    else
      echo "Git push failed -> Aborting script"
      exit 1
    fi
  else
    echo "Aborting script. Current branch is not $CurreBN"
    exit 1
  fi
else
  echo "Process without git commit & push."
fi

# Create Dockerfile
cat <<EOF >"$DFILE"
# dockerfile create
FROM node:18.17.0-alpine
RUN apk add --no-cache tzdata curl
RUN ln -snf /usr/share/zoneinfo/Asia/Calcutta /etc/localtime && echo Asia/Calcutta > /etc/timezone
WORKDIR /app
COPY . /app
RUN npm i
VOLUME [ "/app" ]
EXPOSE 4111
# HEALTHCHECK --interval=180s --timeout=3s CMD curl -fsS http://localhost:4111/v4/health || exit 1
CMD ["npm","start"]
EOF
echo -e "${CYN}${DFILE} ${NC}is created"

# Check if Docker is running and start it if not
if ! docker stats --no-stream >/dev/null 2>&1; then
  if [[ $(uname) == "Darwin" ]]; then
    OS="macOS"
    open --background -a Docker
  elif [[ $(uname) == "Linux" ]]; then
    OS="Linux"
  else
    OS="Windows"
    if [ -f "/c/Program Files/Docker/Docker/Docker Desktop.exe" ]; then
      start "" "/c/Program Files/Docker/Docker/Docker Desktop.exe" %1
    else
      echo "Docker Desktop is not installed or the path is incorrect."
    fi
  fi
  while ! docker stats --no-stream >/dev/null 2>&1; do
    echo "Waiting for Docker to launch..."
    sleep 1
  done
fi

# Build Docker image
docker build -f "$DFILE" -t "${DOCKER_USR}/${DOCKER_REPO}:${TAG_DATE}" .
echo -e "${CYN}Dockerize Build is ${NC}done..."

# Remove Dockerfile if it exists
if [ -f "$DFILE" ]; then
  rm "$DFILE"
  echo -e "${DFILE} is removed"
fi

# Push Docker image to Docker Hub
docker push "${DOCKER_USR}/${DOCKER_REPO}:${TAG_DATE}"
echo -e "${BLE}Docker Hub ${YLW}Image ${NC}push done..."

# # Restart Docker service
# pkill -SIGHUP -f '/Applications/Docker.app' 'docker serve'
# echo -e "${RED}docker is closed${NC}"
echo " "

SSH_COMMAND="ssh -i ~/.ssh/prod-imac root@14.190.8.61 './runbash ${TAG_DATE} 14-admin-deploy-dev.yml true'"

echo "Command -->> ${SSH_COMMAND}"
if ! eval "$SSH_COMMAND"; then
  echo "<<<<<<<<< Prod-Server from command >>>>>>>>>"
fi

echo " "
echo -e "${GRN}================================="
echo -e "${CYN}All ${YLW}Job ${GRN}Completed ${BLE}......."
echo -e "${GRN}================================="


# registry.roleit.com:5443/hum-admin-gql:031123.014528
