# Dockerfile for scale-ci-fio
FROM centos:7

MAINTAINER Red Hat OpenShift Performance and Scale

COPY sshd.sh /root/sshd.sh
COPY bashrc /.bashrc

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done) && \
    rm -f /lib/systemd/system/multi-user.target.wants/* && \
    rm -f /etc/systemd/system/*.wants/* && \
    rm -f /lib/systemd/system/local-fs.target.wants/* && \
    rm -f /lib/systemd/system/sockets.target.wants/*udev* && \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl* && \
    rm -f /lib/systemd/system/basic.target.wants/* && \
    rm -f /lib/systemd/system/anaconda.target.wants/* && \
    yum --skip-broken clean all && rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    curl -o /etc/yum.repos.d/pbench.repo https://copr.fedorainfracloud.org/coprs/ndokos/pbench/repo/epel-7/ndokos-pbench-epel-7.repo && \
    yum -y install centos-release-scl-rh centos-release-scl && yum --enablerepo=centos-sclo-rh -y install rh-python36 && \
    yum install --assumeyes openssh-clients openssh-server configtools pbench-agent pbench-fio && \
    yum clean all && \
    adduser default && head -n -1 /etc/passwd > /tmp/passwd && mv /tmp/passwd /etc/passwd && \
    chmod g=u /etc/passwd

ENTRYPOINT ["/root/sshd.sh"]
