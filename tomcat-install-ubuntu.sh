#!/bin/bash
set -e

sudo apt update -y

# sudo apt-cache search tomcat
# sudo apt install default–jdk
# sudo apt install openjdk-11-jdk
java -version

sudo groupadd tomcat
sudo useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat

cd /tmp

curl -O https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.65/bin/apache-tomcat-9.0.65.tar.gz
# wget --no-cookies --no-check-certificate https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.63/bin/apache-tomcat-9.0.63.tar.gz

sudo mkdir -p /opt/tomcat

cd /opt/tomcat
# sudo apt install -y tomcat9 tomcat9-admin
sudo tar xzvf /tmp/apache-tomcat-9.0.65.tar.gz -C /opt/tomcat --strip-components=1

# sudo chgrp -R tomcat /opt/tomcat
sudo chgrp -RH tomcat /opt/tomcat

sudo sh -c 'chmod +x /opt/tomcat/bin/*.sh'

sudo chmod -R g+r conf

sudo chmod g+x conf

sudo chown -R tomcat webapps/ work/ temp/ logs/

sudo update-java-alternatives -l

# sudo nano /etc/systemd/system/tomcat.service
cat << EOF > /etc/systemd/system/tomcat.service
[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking

Environment=JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_Home=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat
Environment=’CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC’
Environment=’JAVA_OPTS.awt.headless=true -Djava.security.egd=file:/dev/v/urandom’
# Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom -Djava.awt.headless=true"

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

User=tomcat
Group=tomcat
UMask=0007
RestartSec=10
Restart=always

[Install]

WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload

sudo systemctl start tomcat
# sudo systemctl status tomcat

cd /opt/tomcat/bin

sudo ./startup.sh run
ss -ltn
# sudo ufw allow 8080
sudo ufw allow 8080/tcp

#sudo nano /opt/tomcat/conf/tomcat-users.xml
# sudo nano /opt/tomcat/webapps/manager/META-INF/context.xml
# sudo nano /opt/tomcat/webapps/host-manager/META-INF/context.xml

# cat << EOF >> /opt/tomcat/conf/tomcat-users.xml
# tomcat-users.xml — Admin User
# <tomcat-users . . .>
# <tomcat-users . . .>
# <user username="admin" password="password" roles="manager-gui,admin-gui"/>
# </tomcat-users>
# EOF

cat << EOF > /opt/tomcat/conf/tomcat-users.xml
<?xml version="1.0" encoding="UTF-8"?>
<tomcat-users>
  <role rolename="manager-gui"/>
  <role rolename="manager-script"/>
  <role rolename="manager-jmx"/>
  <role rolename="manager-status"/>
  <role rolename="admin-gui"/>
  <role rolename="admin-script"/>
  <user username="admin" password="Password" roles="manager-gui, manager-script, manager-jmx, manager-status, admin-gui, admin-script"/>
</tomcat-users>
EOF

# sudo nano /opt/tomcat/webapps/manager/META-INF/context.xml


# sudo systemctl restart tomcat

##How to create war file
# jar -cvf projectname.war *
# jar -cvf my-app.war myfolder/

# mvn archetype:generate -DgroupId=com.sample -DartifactId=web-project -DarchetypeArtifactId=maven-archetype-webapp -DinteractiveMode=false  

##How to deploy the war file
# jar -xvf projectname.war  
# mvn compile war:war

sudo systemctl restart tomcat

echo "All DCS provide Task is done Thank you Sir......."


scp -i ~/.ssh/id_rsa "C:/Users/dinesh/Downloads/ediservice-master.zip" root@192.168.1.73:/opt/tomcat/webapps
ediservice-master.zip
"C:/Users/dinesh/Downloads/ediservice-master.zip"

mvn deploy

mvn archetype:generate -DinteractiveMode=false
mvn war:war -DinteractiveMode=false

sudo apt-cache search jdk
apt install openjdk-17-jdk
apt upgrade -y maven


https://dlcdn.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz
sudo tar xf /apache-maven-3.8.6-bin.tar.gz -C /opt

sudo ln -s /opt/apache-maven-3.8.6 /opt/maven


scp -i ~/.ssh/id_rsa root@192.168.1.73:/home/ubuntu/ediservice-master/target/ediService.war "C:/Users/dinesh/Downloads/ediservice.war"




