### Setup user for build execution and application runtime
FROM registry.access.redhat.com/ubi8/ubi-minimal
COPY root ./

RUN microdnf -y --setopt=tsflags=nodocs install nginx && \
    chmod 755 /etc/nginx/ssl && \
    microdnf clean all 

EXPOSE 8080 8443

### Provide defaults for an executing container
CMD ["./entrypoint.sh"]
