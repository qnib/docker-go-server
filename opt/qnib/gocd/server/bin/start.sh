#!/usr/local/bin/dumb-init /bin/bash

## Restore if needed
if [ $(ls /opt/go-server/artifacts/serverBackups/ |grep backup_ |wc -l) -ne 0 ];then
    /opt/qnib/gocd/server/bin/restore.sh
fi

/opt/go-server/server.sh 2>&1 1>/var/log/go-server.log
echo $$ > /opt/go-server/go-server.pid
tail -f /var/log/go-server.log
