#!/bin/bash

set -e

CYN=$'\e[0;36m'
YLW=$'\e[0;33m'
BLE=$'\e[0;35m'
GRN=$'\e[0;32m'
RED=$'\e[0;31m'
NC=$'\e[0m'


DFILE='Dockerfile'
DOCKER_USR='username'
DOCKER_REPO='hum-platecreate'
TAG_DATE=$(date +'%d%m%y.%H%M%S')

echo "# $DOCKER_USR/$DOCKER_REPO:$TAG_DATE" >> xrun.sh

#Git add,commit & push
read -p "Git push? (Y/N): " confirm
CurreBN="tele_bot_blind_v1.5.250324"
GBRANCH="$(git rev-parse --abbrev-ref HEAD)" # GBRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
    if [[ "$GBRANCH" == "$CurreBN" ]]; then
        echo "${CYN}Current ${YLW}git branch $GBRANCH ${NC}"
        echo
        read -p "Enter git comment: " gitComment
        echo
        git add .
        git commit -am "$gitComment at $TAG_DATE"
        git push origin $GBRANCH -f
        if [[ "$(git push --porcelain)" == *"Done"* ]]; then
            echo "${CYN}[+] git push was successful! for $GBRANCH ${NC}"
        else
            echo '[-] Not git pushed -> Aborting script';
            exit 1;
        fi
    else
        echo 'Aborting script';
        exit 1;
    fi
else
    echo "process without git commit & push....."
fi

#Create Dockerfile
cat << EOF > Dockerfile
# dockerfile $TAG_DATE
FROM python:3.11-slim
LABEL maintainer="dcsurani@gmail.com"
RUN ln -snf /usr/share/zoneinfo/Asia/Calcutta /etc/localtime && echo Asia/Calcutta > /etc/timezone
WORKDIR /app
RUN apt-get update -y
ADD requirements.txt /app/
RUN pip3 install -r requirements.txt
COPY . .
VOLUME ["/app/config"]
EXPOSE 40010
CMD ["python3", "main.py", "runserver", "0.0.0.0:40010"]
EOF

echo "${CYN}$filename ${NC}is created"

#docker engine check on/off
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

docker build -f $DFILE . -t $DOCKER_USR/$DOCKER_REPO:$TAG_DATE
echo "${CYN}Dockerize ${NC}done..."

if [ -f $DFILE ]; then
   rm $DFILE
   echo "$DFILE is removed"
fi

docker push $DOCKER_USR/$DOCKER_REPO:$TAG_DATE
echo "${BLE}docker ${YLW}file ${NC}push done..."

#docker-close from app
# pkill -SIGHUP -f /Applications/Docker.app 'docker serve'


SSH_COMMAND="ssh -i ~/.ssh/prod-imac root@17.138.120.15 '/mnt/role/runbash ${TAG_DATE} 9-hum-play-parity-deploy.yml true'"

echo "Command -->> ${SSH_COMMAND}"
if ! eval "$SSH_COMMAND"; then
  echo "${RED}<<<<<<<<< ${RED}Prod-Server ${RED}from ${RED}command ${RED}>>>>>>>>>"
fi

echo "${GRN}============================"
echo "${CYN}All ${YLW}Job ${GRN}Completed ${BLE}.........."
echo "${GRN}============================"

# DockerBuild File name
# username/hum-platecreate:041123.153428
