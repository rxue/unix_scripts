#!/bin/bash
set -x
USER_NAME=$1
apt-get update
if [ $? -eq 0 ]; then
#In case of using Debian instead of Ubuntu, installation of Google Chrome has dependency on /sbin/ldconfig and /sbin/start-stop-daemon, so PATH should contain /sbin
  if ! [[ "$PATH" == *"/sbin"* ]]; then export PATH="$PATH:/sbin"; fi
  source sudoer/configure_functions.sh
  [[ ! $(which vim) ]] && install_vim
  [[ ! $(which eclipse) ]] && install_eclipse
  [[ ! $(which idea) ]] && install_intellij
  [[ ! $(which google-chrome-stable) ]] && install_chrome
#configure_python3
  if [[ ! $(which javac) ]]; then apt-get install default-jdk; fi
  if [[ ! $(which mvn) ]]; then apt-get install maven; fi
# install_system_monitors
#apt-get --assume-yes install fcitx-googlepinyin
# Resolving the bug - "Media change: please insert the disc labeled" - when using apt to install software
# sudo sed -i '/cdrom/d' /etc/apt/sources.list
# add_program_to_gnome_main_menu "/usr/bin/eclipse" "/opt/eclipse/java-neon/eclipse/icon.xpm" "Eclipse Neon"   
# user_1000=`getent passwd 1000 |cut -d':' -f1`
#runuser -l ${user_1000} -c 'wget http://ftp.fau.de/eclipse/che/eclipse-che-4.0.1.zip'
#gpasswd -a ${user_1000} docker
#add_sudoer ${USER_NAME}
  exit
fi
