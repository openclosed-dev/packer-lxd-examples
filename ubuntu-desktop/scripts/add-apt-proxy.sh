#!/bin/bash
set -eu

[ -z "$APT_PROXY" ] && exit 0

echo "Using apt proxy at $APT_PROXY ..."

echo "Acquire::HTTP::Proxy \"http://${APT_PROXY}:3142\";" > /etc/apt/apt.conf.d/01proxy
echo 'Acquire::HTTPS::Proxy "false";' >> /etc/apt/apt.conf.d/01proxy
