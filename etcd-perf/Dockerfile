FROM centos:8

MAINTAINER Red Hat OpenShift Performance and Scale

LABEL RUN="podman run --volume /var/lib/etcd:/var/lib/etcd:Z IMAGE"

RUN yum install epel-release -y && yum install jq fio -y && yum clean all && rm -rf /var/cache/yum

COPY run.sh /tmp/run.sh

ENTRYPOINT ["/tmp/run.sh"]
