#!/bin/bash
set -eu

apt-get install -y --no-install-recommends \
  ifupdown \
  openssh-server \
  build-essential \
  lightdm \
  lxde \
  lxtask \
  lxlauncher \
  xorg \
  xserver-xorg-video-all \
  xserver-xorg-input-all \
  desktop-base

apt-get install -y --no-install-recommends \
  firefox-esr \
  fonts-droid-fallback \
  fonts-freefont-ttf \
  fonts-noto-mono \
  unzip \
  usermode \
  zutty

timedatectl set-timezone Asia/Tokyo
 