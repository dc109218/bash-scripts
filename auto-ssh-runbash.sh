#!/usr/bin/env bash

set -e

# ssh -i ~/.ssh/role-prod-imac root@146.190.8.61 './runbash 161023.131134 6-atway-server-deploy.yml true'

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <image_tag> <yml_name> <true/false>"
    exit 1
fi

TAG_DATE=$(date +'%d%m%y.%H%M%S')
NOW=$(date +"%d/%m/%y %H:%M:%S")
DPATH="/root/temp"


if [ "$2" = "6-atway-server-deploy.yml" ]; then
    IMGNAME="username/atway-gql-dev:$1"
    MPATH="/rit/k8s/dev"
elif [ "$2" = "9-atway-engine-deploy.yml" ]; then
    IMGNAME="username/hum-node-engine:$1"
    MPATH="/rit/k8s/dev"
elif [ "$2" = "6-hum-prod-server-deploy.yml" ]; then
    IMGNAME="username/hum-gql-prod:$1"
    MPATH="/rit/k8s/prod/app"
elif [ "$2" = "8-hum-prod-engine-deploy.yml" ]; then
    IMGNAME="username/hum-node-engine:$1"
    MPATH="/rit/k8s/prod/app"
elif [ "$2" = "9-hum-play-parity-deploy.yml" ]; then
    IMGNAME="username/hum-platecreate:$1"
    MPATH="/rit/k8s/prod/bot"
elif [ "$2" = "6-hum-website-deploy.yml" ]; then
    IMGNAME="username/hum-website:$1"
    MPATH="/rit/k8s/prod/web"
elif [ "$2" = "6-admin-gql-deploy.yml" ]; then
    IMGNAME="username/hum-admin-gql:$1"
    MPATH="/rit/k8s/prod/admin"
elif [ "$2" = "8-vegi-pay-getway-deploy.yml" ]; then
    IMGNAME="username/vegi-gateway:$1"
    MPATH="/rit/k8s/vegitable"
elif [ "$2" = "8-hum-webpay-deploy.yml" ]; then
    IMGNAME="username/hum-other-webapp:$1"
    MPATH="/rit/k8s/prod/web"
elif [ "$2" = "14-admin-deploy-dev.yml" ]; then
    IMGNAME="username/hum-admin-gql:$1"
    MPATH="/rit/k8s/dev"
elif [ "$2" = "12-hum-webapp-deploy.yml" ]; then
    IMGNAME="username/hum-webapp:$1"
    MPATH="/rit/k8s/prod/web"
elif [ "$2" = "6-getway-pay-deploy.yml" ]; then
    IMGNAME="username/hum-gateway-payment:$1"
    MPATH="/rit/k8s/prod/gateway"
elif [ "$2" = "16-gateway-server-deploy.yml" ]; then
    IMGNAME="username/hum-gateway-payment_dev:$1"
    MPATH="/rit/k8s/dev"
elif [ "$2" = "4-foster-front-deploy.yaml" ]; then
    IMGNAME="username/newsarefrontend:$1"
    MPATH="/rit/k8s/foster"
elif [ "$2" = "8-foster-back-backend-deploy.yaml" ]; then
    IMGNAME="username/foster-backend-server:$1"
    MPATH="/rit/k8s/foster"
else
    echo "[-] Wrong file name...!"
    exit 1
fi


if [ -f "$DPATH/$2" ]; then
    mv -f "$DPATH/$2" "$DPATH/old/$2.$1"
    cp -f "$MPATH/$2" "$DPATH/$2"
    echo -e "K8s yaml is moved"
else
    cp -f "$MPATH/$2" "$DPATH/$2"
    echo -e "K8s yaml is copyed"
fi

#docker pull "$IMGNAME"
#echo "docker image pull done.........$1"

sed -i "s|111111|$IMGNAME|g" "$DPATH/$2"
echo "K8S file name changed"

if [ "$3" = "true" ]; then
    echo "Action is true"
    echo "$IMGNAME"
    microk8s kubectl apply -f "$DPATH/$2"
    echo "$NOW, $1 $2 $3" >> logs.md
    echo "Deploy done........."
    exit 1
else 
    while true; do
        hour=$(date +"%H")
        minutes=$(date +"%M" | sed 's/^0*//')
        seconds=$(date +"%S" | sed 's/^0*//')

        secondCount=$((60 - (seconds % 60)))
        minuteCount=$((2 - (minutes % 3)))

        printf "<< %02d:%02d >>\n" "$minuteCount" "$secondCount"

        if [ "$minuteCount" -eq 2 ] && [ "$secondCount" -eq 55 ]; then
            echo "$IMGNAME"
            microk8s kubectl apply -f "$DPATH/$2"
            echo "$NOW, $1 $2 $3" >> logs.md
            echo "Deploy done........."
            exit 1
        fi
        sleep 1
    done
fi