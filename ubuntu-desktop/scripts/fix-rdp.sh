#!/bin/sh
set -eu

cat <<EOF > /etc/xrdp/startubuntu.sh
#!/bin/sh
export GNOME_SHELL_SESSION_MODE=ubuntu
export XDG_CURRENT_DESKTOP=ubuntu:GNOME
exec /etc/xrdp/startwm.sh
EOF

chmod 755 /etc/xrdp/startubuntu.sh

sed -i -e 's/startwm/startubuntu/g' /etc/xrdp/sesman.ini
sed -i -e 's/FuseMountName=thinclient_drives/FuseMountName=shared-drives/g' /etc/xrdp/sesman.ini
