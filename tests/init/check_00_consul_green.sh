#!/bin/bash

function ccli {
    docker run -ti --net stacktest_gocd qnib/alpn-consul consul-cli $@
}

count=0
while [ true ];do
    echo "# Wait for consul service to 'passing'"
    ccli --consul consul:8500 health service consul |egrep "Status.*passing"
    if [ $? -eq 0 ];then
        echo ""
        echo "## Took ${count} seconds"
        break
    else
        echo -n "."
    fi
    count=$(echo ${count}+1 | bc)
    sleep 1
done

#curl -s -H 'Accept: application/vnd.go.cd.v2+json' 'http://gocd-server:8153/go/api/agents' |jq "._embedded.agents |length"
