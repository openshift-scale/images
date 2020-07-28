# Dockerfile for scale-ci-base
FROM quay.io/pbench/pbench-agent-tools-centos-7:latest

MAINTAINER Red Hat OpenShift Performance and Scale

COPY sshd.sh /root/sshd.sh

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done) && \
    rm -f /lib/systemd/system/multi-user.target.wants/* && \
    rm -f /etc/systemd/system/*.wants/* && \
    rm -f /lib/systemd/system/local-fs.target.wants/* && \
    rm -f /lib/systemd/system/sockets.target.wants/*udev* && \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl* && \
    rm -f /lib/systemd/system/basic.target.wants/* && \
    rm -f /lib/systemd/system/anaconda.target.wants/* && \
    yum --skip-broken clean all && \
    yum install --assumeyes openssh-clients openssh-server && \
    yum clean all && \
    adduser default && \
    head -n -1 /etc/passwd > /tmp/passwd && \
    mv /tmp/passwd /etc/passwd && \
    chmod g=u /etc/passwd

ENTRYPOINT ["/root/sshd.sh"]
