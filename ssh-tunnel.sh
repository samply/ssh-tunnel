#!/bin/ash
# shellcheck shell=dash

if [ -z "$SSH_TUNNEL_USERNAME" ]; then
  echo "SSH_TUNNEL_USERNAME not defined. Exiting"
  exit 1
fi

if [ -z "$SSH_TUNNEL_HOST" ]; then
  echo "SSH_TUNNEL_HOST not defined. Exiting"
  exit 1
fi

PORT_STRING=$( paste -sd "&" ssh-tunnel.conf | sed "s/&/ -L /g" )
# Double quotes around PORT STRING omitted intentionally
ssh -oBatchMode=yes -4 -o StrictHostKeyChecking=accept-new -v -i /run/secrets/privkey -N -L ${PORT_STRING} "${SSH_TUNNEL_USERNAME}@${SSH_TUNNEL_HOST}"

