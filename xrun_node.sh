#!/bin/bash

echo "start\n"
set -e

CYN=$'\e[0;36m'
YLW=$'\e[0;33m'
BLE=$'\e[0;35m'
GRN=$'\e[0;32m'
RED=$'\e[0;31m'
NC=$'\e[0m'

DFILE='Dockerfile'
DOCKER_USR='registry.hum.com:5443'
DOCKER_REPO='chatsocket-pro'
TAG_DATE=$(date +'%d%m%y.%H%M%S')

if [ -f package-lock.json ]; then
  rm -rf package-lock.json
  echo "[+] package-lock.json is removed"
else
  echo "not have file"
fi

if [ -e node_modules ]; then
  rm -rf node_modules/
  echo "[+] node_modules is removed"
else
  echo "not have file"
fi

echo "# ${DOCKER_USR}/${DOCKER_REPO}:${TAG_DATE}" >> xrun.sh

#Git add,commit & push
read -p "Git push? (Y/N): " confirm
CurreBN="az-sr-24.20.103.103.103v1.2-rel021022"
GBRANCH="$(git rev-parse --abbrev-ref HEAD)" # GBRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
    if [[ "$GBRANCH" == "$CurreBN" ]]; then
        echo "${CYN}Current ${YLW}git branch $GBRANCH ${NC}"
        echo
        read -p "Enter git comment: " gitComment
        echo
        git add .
        git commit -am "$gitComment at $TAG_DATE"
        git push origin $GBRANCH
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
# dockerfile create
FROM node:14.17.5-alpine
RUN apk add --no-cache tzdata curl
RUN ln -snf /usr/share/zoneinfo/Asia/Calcutta /etc/localtime && echo Asia/Calcutta > /etc/timezone
RUN mkdir -p /socket
WORKDIR /socket
COPY . /socket
RUN npm install --no-package-lock
VOLUME ["socket"]
EXPOSE 19786
CMD ["npm","start"]
EOF
echo "${CYN}$filename ${NC}is created"

#docker engine check on/off
if (! docker stats --no-stream ); then
    # open /Applications/Docker.app
    open --background -a Docker
    # "C:\Program Files\Docker\Docker\Docker Desktop.exe" &
  while (! docker stats --no-stream ); do
     echo "Waiting for Docker to launch..."
    sleep 1
  done
fi

docker build -f ${DFILE} . -t ${DOCKER_USR}/${DOCKER_REPO}:${TAG_DATE} #--no-cache
echo "${CYN}Dockerize Build is ${NC}done..."

# sleep 1;
if [ -f ${DFILE} ]; then
   rm ${DFILE};
   echo "${DFILE} is removed";
fi

docker push ${DOCKER_USR}/${DOCKER_REPO}:$TAG_DATE
echo "${BLE}Docker Hub ${YLW}Image ${NC}push done..."

#docker-close from app
# pkill -SIGHUP -f /Applications/Docker.app 'docker serve'
echo "${RED}docker i sclosed${NC}"

echo "${GRN}============================"
echo "${CYN}All ${YLW}Job ${GRN}Completed ${BLE}.........."
echo "${GRN}============================"

#DockerBuild File name
#hum/chatsocket-pro:250922.121856
