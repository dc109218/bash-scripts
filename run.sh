#! /usr/bin/bash

INST='choco install -y'

#git
$INST git
echo '>>-----Done == git'
echo "alias c='clear'" >> 'C:\Program Files\Git\etc\profile.d\aliases.sh'
echo "alias k='kubectl'" >> 'C:\Program Files\Git\etc\profile.d\aliases.sh'
echo "alias d='docker'" >> 'C:\Program Files\Git\etc\profile.d\aliases.sh'


#awscli
$INST awscli
echo '-----Done == awscli'

#aws-iam-authenticator
$INST aws-iam-authenticator
echo '-----Done == aws-iam-authenticator'

#eksctl
$INST eksctl
echo '-----Done == eksctl'

#kubernetes-cli
$INST kubernetes-cli
echo '-----Done == kubernetes-cli'

#vscode
$INST vscode
echo '-----Done == vscode'

#terraform
$INST terraform
echo '-----Done == terraform'

#docker-desktop
$INST docker-desktop
echo '-----Done == docker-desktop'

#docker-compose
$INST docker-compose
echo '-----Done == docker-compose'

#mongodb-compass
$INST mongodb-compass --version=1.32.2
echo '-----Done == mongodb-compass'

#nodejs
$INST nodejs --version=16.4.0
echo '-----Done == nodejs --version=16.4.0'

#postman
$INST postman --version=9.19.0
echo '-----Done == postman'

#skype
$INST skype
echo '-----Done == postman'

#create file
filename='run.sh'
if [ -f $filename ]; then
   rm $filename
   echo "$filename is removed"
fi

