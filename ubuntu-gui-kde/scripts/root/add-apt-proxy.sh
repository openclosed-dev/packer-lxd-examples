#!/bin/bash
set -eu

[ -z "$APT_PROXY" ] && exit 0

echo "Using apt proxy at $APT_PROXY ..."

echo "Acquire::HTTP::Proxy \"${APT_PROXY}\";" > /etc/apt/apt.conf.d/01proxy
echo 'Acquire::HTTPS::Proxy "false";' >> /etc/apt/apt.conf.d/01proxy
