#! /bin/bash

rm -rf node_modules

git add . 
git commit -m "updat for whatsapp mobile numbor"
git push prod main

rm -rf package-lock.json
npm i -f --no-package-lock

rm -rf build
npm run build

rm -rf out
npm run export

rm -rf node_modules

filename='dockerfile'

cat << EOF > dockerfile
# dockerfile create
FROM nginx:stable-alpine-perl
RUN ln -snf /usr/share/zoneinfo/Asia/Calcutta /etc/localtime && echo Asia/Calcutta > /etc/timezone
RUN mkdir -p /app
RUN chmod -R 755 /app
WORKDIR /app
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY out /app
EXPOSE 10050
CMD ["nginx", "-g", "daemon off;"]
EOF
echo "$filename is created"

TAG_DATE=$(date +'%d%m%y.%H%M%S')

docker build -f dockerfile . -t user/newappfrontend:$TAG_DATE --no-cache
echo "Dockerize done..."

docker push user/newsarefrontend:$TAG_DATE
echo "docker file push done..."

# sleep 1

if [ -f $filename ]; then
   rm $filename
   echo "$filename is removed"
fi


