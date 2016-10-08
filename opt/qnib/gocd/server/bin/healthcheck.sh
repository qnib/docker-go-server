#!/usr/local/bin/dumb-init /bin/bash

echo "> curl -sI localhost:8153"
OUTPUT=$(curl -sI localhost:8153)
if [ $? -ne 0 ];then
   exit 1
else
   echo ${OUTPUT} |grep "Moved Permanently"
   exit $?
fi
