#!/bin/bash
set -e

CYN=$'\e[0;36m'
YLW=$'\e[0;33m'
BLE=$'\e[0;35m'
GRN=$'\e[0;32m'
RED=$'\e[0;31m'
NC=$'\e[0m'

DFILE='Dockerfile'
DOCKER_USR='registry.roleit.com:5443'
DOCKER_REPO='alpyimages-pro'
TAG_DATE=$(date +'%d%m%y.%H%M%S')

echo "# $DOCKER_USR/$DOCKER_REPO:$TAG_DATE" >> xrun.sh

#Git add,commit & push
read -p "Git push? (Y/N): " confirm
CurreBN="24.20.103.103.103v1.1-rel041022"
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
FROM python:3.6-slim
LABEL maintainer="dcsurani@gmail.com"
RUN ln -snf /usr/share/zoneinfo/Asia/Calcutta /etc/localtime && echo Asia/Calcutta > /etc/timezone
RUN mkdir /roleitPyImagesAL
WORKDIR /roleitPyImagesAL
RUN apt -y update
RUN apt install -y libopencv-dev python3-opencv curl
COPY requirements.txt /roleitPyImagesAL/
RUN pip3 install -r requirements.txt
COPY . /roleitPyImagesAL/
VOLUME ["roleitPyImagesAL"]
# EXPOSE 20070
# CMD ["python3", "manage.py", "runserver", "0.0.0.0:20070"]
EOF
echo "${CYN}$filename ${NC}is created"

#docker engine check on/off
if (! docker stats --no-stream ); then
    echo "docker is Opening..."
    # open /Applications/Docker.app
    open -a Docker
    # "C:\Program Files\Docker\Docker\Docker Desktop.exe" &
  while (! docker stats --no-stream ); do
     echo "Waiting for Docker to launch..."
    sleep 1
  done
fi

docker build -f $DFILE . -t $DOCKER_USR/$DOCKER_REPO:$TAG_DATE --no-cache
echo "${CYN}Dockerize ${NC}done..."

# sleep 1
if [ -f $DFILE ]; then
   rm $DFILE
   echo "$DFILE is removed"
fi

docker push $DOCKER_USR/$DOCKER_REPO:$TAG_DATE
echo "${BLE}docker ${YLW}file ${NC}push done..."

#docker-close from app
# pkill -SIGHUP -f /Applications/Docker.app 'docker serve'
echo "${RED}docker i sclosed${NC}"

echo "${GRN}============================"
echo "${CYN}All ${YLW}Job ${GRN}Completed ${BLE}.........."
echo "${GRN}============================"

# DockerBuild File name
# dcsurani/alpyimages-pro:151022.181403
# dcsurani/alpyimages-pro:151022.190141
# dcsurani/alpyimages-pro:151022.224925
# dcsurani/alpyimages-pro:311022.115936
# dcsurani/alpyimages-pro:311022.165259

# dcsurani/alpyimages-pro:131122.202658
# dcsurani/alpyimages-pro:131122.202711
# dcsurani/alpyimages-pro:131122.202728
# dcsurani/alpyimages-pro:141122.075129
# dcsurani/alpyimages-pro:141122.114803
# dcsurani/alpyimages-pro:141122.115157
# dcsurani/alpyimages-pro:141122.144809
# dcsurani/alpyimages-pro:141122.170012
# dcsurani/alpyimages-pro:141122.170127
# dcsurani/alpyimages-pro:141122.170222
# dcsurani/alpyimages-pro:141122.170252
# dcsurani/alpyimages-pro:141122.170310
# dcsurani/alpyimages-pro:141122.215730
# dcsurani/alpyimages-pro:141122.221517
# dcsurani/alpyimages-pro:141122.221555
# dcsurani/alpyimages-pro:141122.233128
# dcsurani/alpyimages-pro:141122.233216
# dcsurani/alpyimages-pro:141122.233311
# dcsurani/alpyimages-pro:141122.235922
# dcsurani/alpyimages-pro:151122.000126
# dcsurani/alpyimages-pro:151122.081855
# dcsurani/alpyimages-pro:151122.082006
# dcsurani/alpyimages-pro:151122.084028
# dcsurani/alpyimages-pro:151122.091433
# dcsurani/alpyimages-pro:171122.124520
# dcsurani/alpyimages-pro:171122.163256
# dcsurani/alpyimages-pro:171122.164308
# dcsurani/alpyimages-pro:171122.170118
# dcsurani/alpyimages-pro:171122.173238
# dcsurani/alpyimages-pro:181122.180158
# dcsurani/alpyimages-pro:181122.181242
# dcsurani/alpyimages-pro:181122.181904
# dcsurani/alpyimages-pro:181122.181958
# dcsurani/alpyimages-pro:181122.204424
# dcsurani/alpyimages-pro:051222.212005
# dcsurani/alpyimages-pro:051222.220733
# dcsurani/alpyimages-pro:051222.221241
# dcsurani/alpyimages-pro:051222.221545
# dcsurani/alpyimages-pro:051222.221701
# dcsurani/alpyimages-pro:051222.221932
# dcsurani/alpyimages-pro:051222.222320
# dcsurani/alpyimages-pro:051222.222353
# dcsurani/alpyimages-pro:051222.222445
# dcsurani/alpyimages-pro:051222.222530
# dcsurani/alpyimages-pro:051222.230211
# dcsurani/alpyimages-pro:051222.230249
# dcsurani/alpyimages-pro:051222.230259
# dcsurani/alpyimages-pro:111222.164926
# dcsurani/alpyimages-pro:111222.165002
# dcsurani/alpyimages-pro:111222.165055
# dcsurani/alpyimages-pro:111222.165107
# dcsurani/alpyimages-pro:111222.165216
# dcsurani/alpyimages-pro:181222.175846
# dcsurani/alpyimages-pro:181222.175925
# dcsurani/alpyimages-pro:181222.180128
# dcsurani/alpyimages-pro:181222.180605
# dcsurani/alpyimages-pro:181222.180639
# dcsurani/alpyimages-pro:181222.180702
# dcsurani/alpyimages-pro:181222.180712
# dcsurani/alpyimages-pro:181222.181105
# dcsurani/alpyimages-pro:181222.181235
# dcsurani/alpyimages-pro:181222.181325
# dcsurani/alpyimages-pro:181222.182029
# dcsurani/alpyimages-pro:181222.182114
# dcsurani/alpyimages-pro:181222.182621
# dcsurani/alpyimages-pro:181222.182935
# dcsurani/alpyimages-pro:181222.183143
# dcsurani/alpyimages-pro:181222.183309
# dcsurani/alpyimages-pro:181222.183318
# dcsurani/alpyimages-pro:181222.183352
# dcsurani/alpyimages-pro:181222.183416
# dcsurani/alpyimages-pro:181222.184207
# dcsurani/alpyimages-pro:181222.185017
# dcsurani/alpyimages-pro:181222.185122
# dcsurani/alpyimages-pro:181222.203224
# dcsurani/alpyimages-pro:181222.203300
# dcsurani/alpyimages-pro:181222.203732
# dcsurani/alpyimages-pro:181222.211427
# dcsurani/alpyimages-pro:181222.214917
# dcsurani/alpyimages-pro:181222.223732
# dcsurani/alpyimages-pro:181222.233557
# dcsurani/alpyimages-pro:181222.234203
# dcsurani/alpyimages-pro:181222.234336
# dcsurani/alpyimages-pro:181222.234505
# dcsurani/alpyimages-pro:181222.234635
# dcsurani/alpyimages-pro:181222.234731
# dcsurani/alpyimages-pro:181222.234837
# dcsurani/alpyimages-pro:100423.022243
# dcsurani/alpyimages-pro:100423.023017
# dcsurani/alpyimages-pro:100423.023255
# dcsurani/alpyimages-pro:100423.033400
# dcsurani/alpyimages-pro:100423.040703
# dcsurani/alpyimages-pro:150423.231443
# dcsurani/alpyimages-pro:150423.233403
# dcsurani/alpyimages-pro:170423.190630
