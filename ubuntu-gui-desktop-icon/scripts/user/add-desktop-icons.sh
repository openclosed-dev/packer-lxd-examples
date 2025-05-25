#!/bin/bash
set -eu

mkdir -p $HOME/Desktop

# Add .desktop file as an example.
cat <<EOF > $HOME/Desktop/gedit.desktop
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
for file in $HOME/Desktop/*.desktop; do
  chmod u+x $file
  dbus-launch gio set $file metadata::trusted true
done
