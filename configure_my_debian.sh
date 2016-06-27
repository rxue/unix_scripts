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
# install Java 8
wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u92-b14/jdk-8u92-linux-x64.tar.gz
## ref: http://www.tldp.org/LDP/Linux-Filesystem-Hierarchy/html/usr.html 
tar xvzf jdk-8u92-linux-x64.tar.gz -C /usr/lib
rm jdk-8u92-linux-x64.tar.gz
