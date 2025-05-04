#!/bin/bash
set -eu

echo 'users: []' > /etc/cloud/cloud.cfg.d/90_users.cfg

# Default user requires this group
groupadd --system netdev
