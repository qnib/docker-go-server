FROM qnib/alpn-jre7

ENV GOCD_VER=16.1.0 \
    GOCD_SUBVER=2855
RUN apk update && \
    apk add wget && \
    wget -qO /tmp/go-server.zip https://download.go.cd/binaries/${GOCD_VER}-${GOCD_SUBVER}/generic/go-server-${GOCD_VER}-${GOCD_SUBVER}.zip && \
    mkdir -p /opt/ && cd /opt/ && \
    unzip -q /tmp/go-server.zip && rm -f /tmp/go-server.zip && \
    mv /opt/go-server-${GOCD_VER} /opt/go-server && \
    rm -rf /var/cache/apk/* /tmp/*
RUN chmod +x /opt/go-server/*server.sh
ENV DOCKER_TASK_VER=0.1.23 \
    SCRIPT_EXEC_VER=0.2
RUN mkdir -p /opt/go-server/plugins/external/ && \
    cd /opt/go-server/plugins/external/ && \
    wget -q https://github.com/manojlds/gocd-docker/releases/download/${DOCKER_TASK_VER}/docker-task-assembly-${DOCKER_TASK_VER}.jar && \
    wget -q https://github.com/gocd-contrib/script-executor-task/releases/download/${SCRIPT_EXEC_VER}/script-executor-${SCRIPT_EXEC_VER}.jar
RUN apk update && \
    apk add git
ADD etc/supervisord.d/gocd-server.ini /etc/supervisord.d/
ADD opt/qnib/gocd/server/bin/start.sh /opt/qnib/gocd/server/bin/
