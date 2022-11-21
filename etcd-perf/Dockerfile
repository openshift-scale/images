FROM quay.io/centos/centos:stream9

MAINTAINER Red Hat OpenShift Performance and Scale

LABEL RUN="podman run --volume /var/lib/etcd:/var/lib/etcd:Z IMAGE"

RUN dnf install jq fio -y && dnf clean all && rm -rf /var/cache/dnf

COPY run.sh /tmp/run.sh

ENTRYPOINT ["/tmp/run.sh"]
