#!/bin/bash -eux

echo "==> Setup emacs init file"
mkdir -p $HOME/.emacs.d
cat << EOF > $HOME/.emacs.d/init.el
(setq inhibit-startup-screen t)
(setq default-frame-alist '((height . 24)))
EOF
username=$(basename $HOME)
uid=$(id -u $username)
gid=$(id -g $username)
chown -R $uid:$gid $HOME/.emacs.d
