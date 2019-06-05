FROM centos:7 AS builder
COPY . .
### Install required packages
RUN yum -y --setopt=tsflags=nodocs install automake autotools bc epel-release \
        gcc git gnuplot libtool make openssh-clients patch && \
    yum -y --setopt=tsflags=nodocs install go stress && \
    mkdir -p build && cd build && \
    git clone https://github.com/openshift/svt.git && \
      cd svt/utils/pctl && go build pctl.go && cp pctl /usr/local/bin && cd ../../.. && \
    git clone https://github.com/jmencak/mb.git && \
      cd mb && make && cp ./mb /usr/local/bin && cd .. && \
    cd && rm -rf build && \
    yum remove automake autotools gcc go libtool make patch -y && \
    yum clean all

FROM centos:7
### Setup user for build execution and application runtime
ENV APP_ROOT=/opt/stress
ENV PATH=${APP_ROOT}/bin:${PATH} HOME=${APP_ROOT}
WORKDIR ${APP_ROOT}
COPY root ./
COPY --from=builder /usr/local/bin /usr/local/bin
RUN yum -y --setopt=tsflags=nodocs install bc epel-release \
        gnuplot net-tools openssh-clients rsync && \
    yum -y --setopt=tsflags=nodocs install jq stress && \
    curl -L https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
         -o /usr/local/bin/kubectl && \
      chmod 755 /usr/local/bin/kubectl && \
    yum clean all

### User name recognition at runtime with an arbitrary uid (OpenShift deployments)
RUN chmod -R u+x ${APP_ROOT}/bin && \
    chgrp -R 0 ${APP_ROOT} && \
    chmod -R g=u ${APP_ROOT} /etc/passwd
ENTRYPOINT [ "uid_entrypoint" ]

### Provide defaults for an executing container
CMD run
