#!/bin/bash
set -eu

apt-get install -y --no-install-recommends \
  openssh-server \
  lightdm \
  lxde \
  lxtask \
  lxlauncher \
  xorg \
  xserver-xorg-video-all \
  xserver-xorg-input-all \
  desktop-base
