#! /bin/bash
set -e

CYN=$'\e[0;36m'
YLW=$'\e[0;33m'
BLE=$'\e[0;35m'
GRN=$'\e[0;32m'
RED=$'\e[0;31m'
NC=$'\e[0m'

DFILE='Dockerfile'
DOCKER_USR='username'
DOCKER_REPO='alpyimages-pro'
GBRANCH="$(git rev-parse --abbrev-ref HEAD)" # GBRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
if [[ "$GBRANCH" != "23.18.10x.10x.102v1.0-release0300522" ]]; then
  echo 'Aborting script';
  exit 1;
fi
echo "${CYN}Current ${YLW}git branch $GBRANCH ${NC}"

git add .
git commit -m "update for status video and images perameater"
git push origin $GBRANCH
echo "${CYN}git push done for $GBRANCH ${NC}"

cat << EOF > Dockerfile
# dockerfile create
FROM python:3.6-slim
RUN ln -snf /usr/share/zoneinfo/Asia/Calcutta /etc/localtime && echo Asia/Calcutta > /etc/timezone
RUN mkdir /roleitPyImagesAL
WORKDIR /roleitPyImagesAL
COPY requirements.txt /roleitPyImagesAL
RUN pip3 install -r requirements.txt
RUN apt update -y && apt install -y python3-opencv
COPY . /roleitPyImagesAL
EOF
echo "${CYN}$filename ${NC}is created"

TAG_DATE=$(date +'%d%m%y.%H%M%S')

docker build -f $DFILE . -t $DOCKER_USR/$DOCKER_REPO:$TAG_DATE --no-cache
echo "${CYN}Dockerize ${NC}done..."

docker push $DOCKER_USR/$DOCKER_REPO:$TAG_DATE
echo "${BLE}docker ${YLW}file ${NC}push done..."

# sleep 1

if [ -f $DFILE ]; then
   rm $DFILE
   echo "$DFILE is removed"
fi

echo "${GRN}============================"
echo "${CYN}All ${YLW}Job ${GRN}Completed ${BLE}.........."
echo "${GRN}============================"

