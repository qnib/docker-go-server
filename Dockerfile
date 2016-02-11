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
