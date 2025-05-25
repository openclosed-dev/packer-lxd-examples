#!/bin/bash
set -eu

# Desktop directory for current user
DESKTOP_DIR=$(xdg-user-dir DESKTOP)

mkdir -p $DESKTOP_DIR

# Add .desktop file as an example.
cat <<EOF > $DESKTOP_DIR/gedit.desktop
[Desktop Entry]
Name=Text Editor
Exec=/usr/bin/gedit %U
StartupNotify=true
Terminal=false
Icon=org.gnome.gedit
Type=Application
EOF

# Make all desktop files executable and trusted.
# Note that dbus-x11 package is required.
for file in $DESKTOP_DIR/*.desktop; do
  chmod u+x $file
  dbus-launch gio set $file metadata::trusted true
done
