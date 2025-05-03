#!/bin/bash
set -eu

apt-get install -y --no-install-recommends \
  xorgxrdp \
  xrdp

adduser xrdp ssl-cert
