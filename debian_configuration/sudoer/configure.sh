#!/bin/bash
USER_NAME=$1
apt-get update
#In case of using Debian instead of Ubuntu, installation of Google Chrome has dependency on /sbin/ldconfig and /sbin/start-stop-daemon, so PATH should contain /sbin
if ! [[ "$PATH" == *"/sbin"* ]]; then export PATH="$PATH:/sbin"; fi
source sudoer/configure_functions.sh
install_vim
#install_chrome
#configure_python3
#apt-get install default-jdk
#apt-get install maven
install_system_monitors
#apt-get --assume-yes install fcitx-googlepinyin
# Resolving the bug - "Media change: please insert the disc labeled" - when using apt to install software
# sudo sed -i '/cdrom/d' /etc/apt/sources.list
# add_program_to_gnome_main_menu "/usr/bin/eclipse" "/opt/eclipse/java-neon/eclipse/icon.xpm" "Eclipse Neon"   
# user_1000=`getent passwd 1000 |cut -d':' -f1`
#runuser -l ${user_1000} -c 'wget http://ftp.fau.de/eclipse/che/eclipse-che-4.0.1.zip'
#gpasswd -a ${user_1000} docker
add_sudoer ${USER_NAME}
exit
