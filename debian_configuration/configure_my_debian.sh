#!/bin/bash
[ `sudo cat /etc/shadow |grep "^root:\!:"` ] && sudo -i passwd root
su -c "source sudoer/install.sh $USER"
# python3 make_shortcut.py "Open Terminal" "gnome-terminal" "<Primary><Alt>t"
python3 python/make_shortcut.py "Open Chrome" "google-chrome" "<Super>c"
source configure_my_debian_functions.sh
configure_git rui ruixue.fi@gmail.com
source deactivate.sh
