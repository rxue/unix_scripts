#!/bin/bash
apt-get -y install sudo
# install Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
while ! dpkg -i google-chrome-stable_current_amd64.deb; do
apt-get -f install
done
# add Chinese locale. ref: https://wiki.archlinux.org/index.php/locale
sed -i "s/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/" /etc/locale.gen
locale-gen

