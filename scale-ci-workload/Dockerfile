# Dockerfile for scale-ci-workload

# First build scraper/compare tools from source in separate container image
FROM golang:1.12 as scraperbuilder

WORKDIR $GOPATH/src/github.com/openshift-scale/perf-analyzer

RUN mkdir -p $GOPATH/src/github.com/openshift-scale/perf-analyzer && \
    git clone https://www.github.com/openshift-scale/perf-analyzer $GOPATH/src/github.com/openshift-scale/perf-analyzer && \
    go get -d -v ./... && cd $GOPATH/src/github.com/openshift-scale/perf-analyzer && make

# Origin-tests for oc/openshift-tests
FROM quay.io/openshift/origin-tests:latest as origintests

FROM centos:7

MAINTAINER Red Hat OpenShift Performance and Scale

ENV KUBECONFIG /root/.kube/config

# Copy OpenShift CLI and cluster loader into container
COPY --from=origintests /usr/bin/oc /usr/bin/oc
COPY --from=origintests /usr/bin/openshift-tests /usr/bin/openshift-tests

# Copy scraper/compare tools into container
COPY --from=scraperbuilder /go/src/github.com/openshift-scale/perf-analyzer/_output/scraper /usr/bin/scraper
COPY --from=scraperbuilder /go/src/github.com/openshift-scale/perf-analyzer/_output/compare /usr/bin/compare

COPY config /root/.ssh/config

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done) && \
    rm -f /lib/systemd/system/multi-user.target.wants/* && \
    rm -f /etc/systemd/system/*.wants/* && \
    rm -f /lib/systemd/system/local-fs.target.wants/* && \
    rm -f /lib/systemd/system/sockets.target.wants/*udev* && \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl* && \
    rm -f /lib/systemd/system/basic.target.wants/* && \
    rm -f /lib/systemd/system/anaconda.target.wants/* && \
    yum --skip-broken clean all && rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    curl -s https://copr.fedorainfracloud.org/coprs/ndokos/pbench/repo/epel-7/ndokos-pbench-epel-7.repo > /etc/yum.repos.d/copr-pbench.repo && \
    yum --skip-broken --enablerepo=ndokos-pbench install -y configtools openssh-clients openssh-server pbench-agent pbench-uperf pbench-fio jq \
    iproute sysvinit-tools pbench-sysstat git ansible which bind-utils blktrace ethtool iotop iptables-services perf wget initscripts \
    gettext python-requests && yum clean all && \
    sed -i "s/#Port 22/Port 2022/" /etc/ssh/sshd_config && \
    chmod g=u /etc/passwd && \
    chmod 600 /root/.ssh/config && \
    systemctl enable sshd

EXPOSE 2022

ENTRYPOINT ["/usr/sbin/init"]
