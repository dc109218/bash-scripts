#!/bin/bash

apt update -y

swapoff -a; sed -i '/swap/d' /etc/fstab

apt install apt-transport-https ca-certificates curl software-properties-common -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update -y

apt-cache policy docker-ce

apt install docker-ce -y

systemctl status docker

apt install docker-compose -y

cat << EOF > /etc/docker/daemon.json
{
    "features": { "buildkit": true },
    "insecure-registries" : ["registry.roleit.com:5443"],
    "allow-nondistributable-artifacts": ["registry.roleit.com:5443"]
}
EOF

systemctl restart docker

cat /rit/pkg/docker.txt | docker login registry.roleit.com:5443 -u dcsurani --password-stdin

apt install redis-tools -y
