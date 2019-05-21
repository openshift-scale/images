# Dockerfile for scale-ci-workload

FROM quay.io/openshift/origin-tests:latest as origintests
FROM centos:7

MAINTAINER Red Hat OpenShift Performance and Scale

ENV KUBECONFIG /root/.kube/config

# Copy OpenShift CLI and cluster loader into container
# COPY oc /usr/bin/oc
# COPY openshift-tests /usr/bin/openshift-tests
COPY --from=origintests /usr/bin/oc /usr/bin/oc
COPY --from=origintests /usr/bin/openshift-tests /usr/bin/openshift-tests
COPY config /root/.ssh/config

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

RUN yum --skip-broken clean all && rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    curl -s https://copr.fedorainfracloud.org/coprs/ndokos/pbench/repo/epel-7/ndokos-pbench-epel-7.repo > /etc/yum.repos.d/copr-pbench.repo && \
    yum --skip-broken --enablerepo=ndokos-pbench install -y configtools openssh-clients openssh-server pbench-agent jq \
    iproute sysvinit-tools pbench-sysstat git ansible which bind-utils blktrace ethtool iotop iptables-services perf wget initscripts && \
    yum clean all && \
    sed -i "s/#Port 22/Port 2022/" /etc/ssh/sshd_config && \
    chmod g=u /etc/passwd && \
    chmod 600 /root/.ssh/config && \
    systemctl enable sshd

VOLUME [ "/sys/fs/cgroup" ]

EXPOSE 2022

ENTRYPOINT ["/usr/sbin/init"]
