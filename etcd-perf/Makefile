

REGISTRY?=quay.io
ORG?=openshift-scale
REPO?=etcd-perf

IMAGE=$(REGISTRY)/$(ORG)/$(REPO)

all: build push

build:
	podman build --platform=linux/amd64,linux/arm64,linux/ppc64le,linux/s390x --manifest=$(IMAGE):latest .
push:
	podman manifest push $(IMAGE):latest $(IMAGE):latest

.PHONY: all build push
