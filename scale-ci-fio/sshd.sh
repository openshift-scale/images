#!/bin/sh

if [[ -v FIO_SSH_PORT ]]; then
  echo "FIO_SSH_PORT set to ${FIO_SSH_PORT}"
else
  export FIO_SSH_PORT=2023
  echo "Defaulting FIO_SSH_PORT to ${FIO_SSH_PORT}"
fi

echo "${USER_NAME:-default}:x:$(id -u):0:${USER_NAME:-default} user:${HOME}:/bin/bash" >> /etc/passwd

mkdir -p /tmp/uperf_ssh
ssh-keygen -f /tmp/uperf_ssh/ssh_host_rsa_key -N '' -t rsa
ssh-keygen -f /tmp/uperf_ssh/ssh_host_dsa_key -N '' -t dsa

echo "Port ${FIO_SSH_PORT}" > /tmp/uperf_ssh/sshd_config
echo "HostKey /tmp/uperf_ssh/ssh_host_rsa_key" >> /tmp/uperf_ssh/sshd_config
echo "HostKey /tmp/uperf_ssh/ssh_host_dsa_key" >> /tmp/uperf_ssh/sshd_config
echo "UsePrivilegeSeparation no" >> /tmp/uperf_ssh/sshd_config
echo "AuthorizedKeysFile .ssh/authorized_keys" >> /tmp/uperf_ssh/sshd_config
echo "ChallengeResponseAuthentication no" >> /tmp/uperf_ssh/sshd_config
echo "UsePAM yes" >> /tmp/uperf_ssh/sshd_config
echo "Subsystem   sftp    /usr/lib/ssh/sftp-server" >> /tmp/uperf_ssh/sshd_config
echo "PidFile /tmp/uperf_ssh/sshd.pid" >> /tmp/uperf_ssh/sshd_config

touch /tmp/sshd.log
/usr/sbin/sshd -E /tmp/sshd.log -f /tmp/uperf_ssh/sshd_config -D &

echo "$(date -u) sleep loop starting"
while :; do
  echo "$(date -u) sshd.log contents:"
  echo "$(cat /tmp/sshd.log)"
  echo "$(date -u) sleeping 5 minutes"
  sleep 300
done
