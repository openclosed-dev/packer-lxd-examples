#!/bin/bash
set -eu

mkdir -p /etc/dconf/profile

cat <<EOF > /etc/dconf/profile/user
user-db:user
system-db:local
EOF

mkdir -p /etc/dconf/db/local.d

cat <<EOF > /etc/dconf/db/local.d/keyfile
[org/gnome/desktop/lockdown]
# Prevent the user from logging out
disable-log-out=true
# Prevent the user from user switching
disable-user-switching=true
# Prevent the user from locking screen
disable-lock-screen=true
EOF

mkdir -p /etc/dconf/db/local.d/locks

# Forbid users to change the settings above
cat <<EOF > /etc/dconf/db/local.d/locks/lockdown
/org/gnome/desktop/lockdown/disable-log-out
/org/gnome/desktop/lockdown/disable-user-switching
/org/gnome/desktop/lockdown/disable-lock-screen
EOF

# Create or update the database
dconf update
