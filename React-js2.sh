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
DOCKER_REPO='mydockerrepo'
GBRANCH="$(git rev-parse --abbrev-ref HEAD)" # GBRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
if [[ "$GBRANCH" != "facebookUpdate05082022" ]]; then
  echo "Aborting script error for $GBRANCH";
  exit 1;
fi
echo "${CYN}Current ${YLW}git branch $GBRANCH ${NC}"

rm -rf node_modules
rm -rf build
rm -rf package-lock.json

npm i -f --no-package-lock
npm run build
echo "${CYN}Roleit ${YLW}Build Done ${NC}"

cat << EOF > ./build/app-ads.txt
# Facebook ads file
hear code add
EOF

# rm -rf node_modules

git add .
git commit -m "update for facebook"
git push origin $GBRANCH
echo "${CYN}git push done for $GBRANCH ${NC}"

cat << EOF > Dockerfile
# dockerfile create
FROM nginx:alpine
RUN ln -snf /usr/share/zoneinfo/Asia/Calcutta /etc/localtime && echo Asia/Calcutta > /etc/timezone
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf
RUN mkdir -p /foster
RUN chmod -R 755 /foster
WORKDIR /foster
COPY /build /foster
EXPOSE 10010
CMD ["nginx", "-g", "daemon off;"]
EOF
echo "${CYN}$DFILE ${NC}is created"

TAG_DATE=$(date +'%d%m%y.%H%M%S')

docker build -f $DFILE . -t $DOCKER_USR/$DOCKER_REPO:$TAG_DATE --no-cache
echo "${CYN}Dockerize ${NC}done..."

docker push $DOCKER_USR/$DOCKER_REPO:$TAG_DATE
echo "${BLE}docker ${YLW}file ${NC}push done..."

if [ -f $DFILE ]; then
   rm $DFILE
   echo "${RED}$DFILE is removed"
fi

echo "#Last create Docker image $DOCKER_USR/$DOCKER_REPO:$TAG_DATE" >> ./run.sh
echo "${GRN}============================"
echo "${CYN}All ${YLW}Job ${GRN}Completed ${BLE}.........."
echo "${GRN}============================"

# docker run --name test1 -p 10010:10010 username/mydockerrepo:050822.112302