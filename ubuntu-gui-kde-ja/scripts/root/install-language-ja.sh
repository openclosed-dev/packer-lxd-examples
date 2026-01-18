#!/bin/bash
set -e

apt-get install -y --no-install-recommends \
  fcitx5 \
  fcitx5-configtool \
  fcitx5-frontend-all \
  fcitx5-mozc \
  fonts-noto-cjk \
  im-config \
  language-pack-ja \
  language-pack-kde-ja \
  mozc-utils-gui

# Change the system-wide locale
localectl set-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja"
im-config -n fcitx5
