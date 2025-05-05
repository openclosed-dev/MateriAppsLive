#!/bin/bash
set -eu

cat <<EOF > /etc/apt/sources.list
deb http://ftp.jp.debian.org/debian bookworm main contrib non-free non-free-firmware
deb-src http://ftp.jp.debian.org/debian bookworm main contrib non-free non-free-firmware

deb http://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware
deb-src http://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware

deb http://ftp.jp.debian.org/debian bookworm-updates main contrib non-free non-free-firmware
deb-src http://ftp.jp.debian.org/debian bookworm-updates main contrib non-free non-free-firmware
EOF
