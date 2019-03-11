#!/bin/bash -xe

apt-get update -y
apt-get install ca-certificates-java -y
apt-get install openjdk-8-jre-headless -y

# First arg to script is count number of instance
# Second arg to script is name of spring config file
cp $2 /tmp/application-override.properties

cd /tmp
wget https://storage.googleapis.com/oreilly-docker-java-shopping/shopfront-0.0.1-SNAPSHOT.jar -c -O app.jar

apt-get install supervisor -y

cat >> /etc/supervisor/supervisord.conf <<EOL
[program:executablejar]
command=java -jar /tmp/app.jar --spring.profiles.active=override --spring.config.location=file:/tmp/application-override.properties
directory=/tmp
autostart=true
autorestart=true
stderr_logfile=/var/log/executablejar.err.log
stdout_logfile=/var/log/executablejar.out.log
EOL

service supervisor restart
