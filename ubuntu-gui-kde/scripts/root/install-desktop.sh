#!/bin/bash
set -e

# A hyphen appended to the package name
# prevents the package from being installed
apt-get install -y --no-install-recommends \
  kde-standard \
  kwin-x11 \
  qml-module-qt-labs-platform \
  plasma-nm-
