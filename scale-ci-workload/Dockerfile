# Dockerfile for scale-ci-workload

# First build scraper/compare tools from source in separate container image
FROM golang as scraperbuilder

WORKDIR $GOPATH/src/github.com/openshift-scale/perf-analyzer

RUN mkdir -p $GOPATH/src/github.com/openshift-scale/perf-analyzer && \
    git clone https://www.github.com/openshift-scale/perf-analyzer $GOPATH/src/github.com/openshift-scale/perf-analyzer && \
    go get -d -v ./... && \
    cd $GOPATH/src/github.com/openshift-scale/perf-analyzer && \
    make

# Build the conprof binary from source in a separate image

WORKDIR $GOPATH/src/github.com/conprof/conprof

RUN mkdir -p $GOPATH/src/github.com/conprof/conprof && \
    git clone https://www.github.com/conprof/conprof $GOPATH/src/github.com/conprof/conprof && \
    cd $GOPATH/src/github.com/conprof/conprof && \
     GO111MODULE=on GOPROXY=https://proxy.golang.org go install -v

# Origin-tests for oc/openshift-tests
FROM quay.io/openshift/origin-tests:4.3 as origintests

FROM quay.io/openshift-scale/scale-ci-base:latest

MAINTAINER Red Hat OpenShift Performance and Scale

ENV KUBECONFIG /root/.kube/config

# Copy conprof binary
COPY --from=scraperbuilder /go/bin/conprof /usr/bin/conprof

# Copy OpenShift CLI, Kubernetes CLI and cluster loader into container
COPY --from=origintests /usr/bin/oc /usr/bin/oc
COPY --from=origintests /usr/bin/openshift-tests /usr/bin/openshift-tests
COPY --from=origintests /usr/bin/kubectl /usr/bin/kubectl

# Copy scraper/compare tools into container
COPY --from=scraperbuilder /go/src/github.com/openshift-scale/perf-analyzer/_output/scraper /usr/bin/scraper
COPY --from=scraperbuilder /go/src/github.com/openshift-scale/perf-analyzer/_output/compare /usr/bin/compare

COPY config /root/.ssh/config

RUN yum --enablerepo=centos-sclo-rh install -y python3 python3-requests && \
    yum install -y openssh-clients openssh-server jq iproute sysvinit-tools git ansible which bind-utils ethtool iotop iptables-services wget initscripts gettext python-requests && \
    yum install -y python36-setuptools && \
    yum clean all && \
    easy_install-2.7 pip && \
    pip2.7 install boto3 && \
    yum install -y python-rbd python-flask && \
    git clone https://github.com/cloud-bulldozer/snafu /tmp/snafu && \
    pip3 install --upgrade-strategy=only-if-needed -e /tmp/snafu && \
    pip3 install gspread gspread-formatting oauth2client && \
    sed -i "s/#Port 22/Port 2022/" /etc/ssh/sshd_config && \
    chmod g=u /etc/passwd && \
    chmod 600 /root/.ssh/config && \
    yum install -y podman && \
    systemctl enable sshd

EXPOSE 2022

ENTRYPOINT ["/usr/sbin/init"]
