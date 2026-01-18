#!/bin/bash
set -e

apt-get install -y --no-install-recommends \
  fcitx5 \
  fcitx5-mozc \
  fcitx5-configtool \
  fonts-noto-cjk \
  gnome-user-docs-ja \
  im-config \
  language-pack-gnome-ja \
  language-pack-ja

# Change the system-wide locale
localectl set-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja"
im-config -n fcitx5
