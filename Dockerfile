FROM qnib/java7

ADD etc/yum.repos.d/gocd.repo /etc/yum.repos.d/
RUN yum install -y go-server

