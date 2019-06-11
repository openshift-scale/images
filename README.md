# Container images
Container Images for Scale-CI

scale-ci-workload image: [![Docker Repository on Quay](https://quay.io/repository/openshift-scale/scale-ci-workload/status "Docker Repository on Quay")](https://quay.io/repository/openshift-scale/scale-ci-workload)

scale-ci-uperf image: [![Docker Repository on Quay](https://quay.io/repository/openshift-scale/scale-ci-uperf/status "Docker Repository on Quay")](https://quay.io/repository/openshift-scale/scale-ci-uperf)

## Quay.io Builds

Each container image is built by quay.io in the [openshift-scale](https://quay.io/organization/openshift-scale) organization.  The builds are triggered by commits into this repo.  In addition we will periodically trigger rebuilds when tools in dependent containers are built and published.  An example of when to trigger a new rebuild would be any updates to cluster loader inside of origin-tests.
