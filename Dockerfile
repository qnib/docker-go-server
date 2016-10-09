FROM qnib/alpn-jre8

RUN apk --no-cache add curl git \
 && curl -Ls https://github.com/qnib/go-github/releases/download/0.2.2/go-github_0.2.2_MuslLinux > /usr/local/bin/go-github \
 && chmod +x /usr/local/bin/go-github
RUN echo "# consul-content: $(/usr/local/bin/go-github rLatestUrl --ghorg qnib --ghrepo service-scripts --regex ".*\.tar" --limit 1)" \
 && curl -Ls $(/usr/local/bin/go-github rLatestUrl --ghorg qnib --ghrepo service-scripts --regex ".*\.tar" --limit 1) |tar xf - -C /opt/
RUN source /opt/service-scripts/gocd/common/version \
 && curl -Ls --url https://download.go.cd/binaries/${GOCD_VER}-${GOCD_SUBVER}/generic/go-server-${GOCD_VER}-${GOCD_SUBVER}.zip > /tmp/go-server.zip
RUN source /opt/service-scripts/gocd/common/version \
 && mkdir -p /opt/ \
 && unzip -q -d /opt/ /tmp/go-server.zip \
 && rm -f /tmp/go-server.zip \
 && mv /opt/go-server-${GOCD_VER} /opt/go-server \
 && rm -rf /var/cache/apk/* /tmp/*
RUN chmod +x /opt/go-server/*server.sh
ENV DOCKER_TASK_VER=0.1.27 \
    SCRIPT_EXEC_VER=0.2 \
    SLACK_NOTIFY_VER=1.3.0 \
    GITHUB_PR_STATUS_VER=1.2 \
    DEB_REPO_POLLER_VER=1.2 \
    SLACK_TASK_VER=1.2 \
    GITHUB_PR_BUILD=1.2.4 \
    GEN_ARTIFACT_POLLER=0.1.0 \
    S3_POLLER=1.0.0 \
    S3_ARTIFACTS_POLLER=2.0.2 \
    GOCD_SERVER_CLEAN_WORKSPACE=false
RUN mkdir -p /opt/go-server/plugins/external/ \
 && cd /opt/go-server/plugins/external/ \
 #&& wget -q https://github.com/manojlds/gocd-docker/releases/download/${DOCKER_TASK_VER}/docker-task-assembly-${DOCKER_TASK_VER}.jar \
 && wget -q https://github.com/gocd-contrib/script-executor-task/releases/download/${SCRIPT_EXEC_VER}/script-executor-${SCRIPT_EXEC_VER}.jar \
 #&& wget -q https://github.com/ashwanthkumar/gocd-slack-build-notifier/releases/download/v${SLACK_NOTIFY_VER}/gocd-slack-notifier-${SLACK_NOTIFY_VER}.jar \
 && wget -q https://github.com/gocd-contrib/gocd-build-status-notifier/releases/download/${GITHUB_PR_STATUS_VER}/github-pr-status-${GITHUB_PR_STATUS_VER}.jar \
 && wget -q https://github.com/gocd-contrib/deb-repo-poller/releases/download/${DEB_REPO_POLLER_VER}/deb-repo-poller-${DEB_REPO_POLLER_VER}.jar \
 #&& wget -q https://github.com/Haufe-Lexware/gocd-plugins/releases/download/v1.0.0-beta/gocd-docker-pipeline-plugin-1.0.0.jar \
 #&& wget -q https://github.com/Vincit/gocd-slack-task/releases/download/v${SLACK_TASK_VER}/gocd-slack-task-${SLACK_TASK_VER}.jar \
 && wget -q https://github.com/ashwanthkumar/gocd-build-github-pull-requests/releases/download/v${GITHUB_PR_BUILD}/github-pr-poller-${GITHUB_PR_BUILD}.jar \
 && wget -q https://github.com/ashwanthkumar/gocd-build-github-pull-requests/releases/download/v${GITHUB_PR_BUILD}/git-fb-poller-${GITHUB_PR_BUILD}.jar \
 #&& wget -q https://github.com/varchev/go-generic-artifactory-poller/releases/download/${GEN_ARTIFACT_POLLER}/go-generic-artifactory-poller.jar \
 #&& wget -q https://github.com/schibsted/gocd-s3-poller/releases/download/${S3_POLLER}/gocd-s3-poller-${S3_POLLER}.jar \
 #&& wget -q https://github.com/ind9/gocd-s3-artifacts/releases/download/v${S3_ARTIFACTS_POLLER}/s3material-assembly-${S3_ARTIFACTS_POLLER}.jar \
 #&& wget -q https://github.com/ind9/gocd-s3-artifacts/releases/download/v${S3_ARTIFACTS_POLLER}/s3fetch-assembly-${S3_ARTIFACTS_POLLER}.jar \
 #&& wget -q https://github.com/ind9/gocd-s3-artifacts/releases/download/v${S3_ARTIFACTS_POLLER}/s3publish-assembly-${S3_ARTIFACTS_POLLER}.jar \
 && echo
ADD etc/supervisord.d/gocd-server.ini /etc/supervisord.d/
ADD opt/qnib/gocd/server/bin/start.sh \
    opt/qnib/gocd/server/bin/restore.sh \
    opt/qnib/gocd/server/bin/healthcheck.sh \
    /opt/qnib/gocd/server/bin/
ADD opt/go-server/config/cruise-config.xml /opt/go-server/config/
ADD etc/consul.d/gocd-server.json /etc/consul.d/
## Docker 1.12
HEALTHCHECK --interval=5s --retries=120 --timeout=2s \
CMD /opt/qnib/gocd/server/bin/healthcheck.sh
