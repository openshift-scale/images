#!/bin/bash

set -e

# Create etcd write dir if it doesn't exist
mkdir -p /var/lib/etcd

# Run fio
echo "---------------------------------------------------------------- Running fio ---------------------------------------------------------------------------"
fio --rw=write --ioengine=sync --fdatasync=1 --directory=/var/lib/etcd --size=22m --bs=2300 --name=etcd_perf --output-format=json | tee /tmp/fio.out
echo "--------------------------------------------------------------------------------------------------------------------------------------------------------"

# Scrape the fio output for p99 of fsync in ns
fsync=$(cat /tmp/fio.out | jq '.jobs[0].sync.lat_ns.percentile["99.000000"]')
echo "99th percentile of fsync is $fsync ns"

# Compare against the recommended value
if [[ $fsync -ge 10000000 ]]; then
  echo "99th percentile of the fsync is greater than the recommended value which is 10 ms, faster disks are recommended to host etcd for better performance"
else
  echo "99th percentile of the fsync is within the recommended threshold - 10 ms, the disk can be used to host etcd"
fi
