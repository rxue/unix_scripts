#!/bin/bash
sudo apt-get update
# Resolving the bug - "Media change: please insert the disc labeled" - when using apt to install software
sudo sed -i '/cdrom/d' /etc/apt/sources.list
add_program_to_gnome_main_menu "/usr/bin/eclipse" "/opt/eclipse/java-neon/eclipse/icon.xpm" "Eclipse Neon"   
user_1000=`getent passwd 1000 |cut -d':' -f1`
#runuser -l ${user_1000} -c 'wget http://ftp.fau.de/eclipse/che/eclipse-che-4.0.1.zip'
#gpasswd -a ${user_1000} docker
