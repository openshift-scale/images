FROM centos:8

MAINTAINER Red Hat OpenShift Performance and Scale

RUN yum install epel-release -y && yum install jq fio -y && yum clean all && rm -rf /var/cache/yum

COPY run.sh /tmp/run.sh

ENTRYPOINT ["/tmp/run.sh"]
