#!/usr/bin/env bash

mvn clean package

echo 'Copy files...'

scp -i ~/.ssh/id_rsa\
    target/sweater-1.0-SNAPSHOT.jar \
    layzeld@192.168.1.126:/home/layzeld

echo 'Restart server...'

ssh -i ~/.ssh/id_rsa layzeld@192.168.1.126 << EOF

pgrep java | xargs kill -9
nohup java -jar sweater-1.0-SNAPSHOT.jar > log.txt &

EOF

echo 'Bye'
