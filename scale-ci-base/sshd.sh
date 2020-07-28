#!/bin/sh

if [[ -v SSH_PORT ]]; then
  echo "SSH_PORT set to ${SSH_PORT}"
else
  export SSH_PORT=2023
  echo "Defaulting SSH_PORT to ${SSH_PORT}"
fi

echo "${USER_NAME:-default}:x:$(id -u):0:${USER_NAME:-default} user:${HOME}:/bin/bash" >> /etc/passwd

mkdir -p /tmp/scale_ci_ssh
ssh-keygen -f /tmp/scale_ci_ssh/ssh_host_rsa_key -N '' -t rsa
ssh-keygen -f /tmp/scale_ci_ssh/ssh_host_dsa_key -N '' -t dsa

echo "Port ${SSH_PORT}" > /tmp/scale_ci_ssh/sshd_config
echo "HostKey /tmp/scale_ci_ssh/ssh_host_rsa_key" >> /tmp/scale_ci_ssh/sshd_config
echo "HostKey /tmp/scale_ci_ssh/ssh_host_dsa_key" >> /tmp/scale_ci_ssh/sshd_config
echo "UsePrivilegeSeparation no" >> /tmp/scale_ci_ssh/sshd_config
echo "AuthorizedKeysFile .ssh/authorized_keys" >> /tmp/scale_ci_ssh/sshd_config
echo "ChallengeResponseAuthentication no" >> /tmp/scale_ci_ssh/sshd_config
echo "UsePAM yes" >> /tmp/scale_ci_ssh/sshd_config
echo "Subsystem   sftp    /usr/lib/ssh/sftp-server" >> /tmp/scale_ci_ssh/sshd_config
echo "PidFile /tmp/scale_ci_ssh/sshd.pid" >> /tmp/scale_ci_ssh/sshd_config

touch /tmp/sshd.log
/usr/sbin/sshd -E /tmp/sshd.log -f /tmp/scale_ci_ssh/sshd_config -D &

echo "$(date -u) sleep loop starting"
while :; do
  echo "$(date -u) sshd.log contents:"
  echo "$(cat /tmp/sshd.log)"
  echo "$(date -u) sleeping 5 minutes"
  sleep 300
done
