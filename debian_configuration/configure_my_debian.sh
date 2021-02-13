#!/bin/bash
su -c "source sudoer/configure.sh $USER"
python3 make_shortcut.py "Open Terminal" "gnome-terminal" "<Primary><Alt>t"
python3 make_shortcut.py "Open Chrome" "google-chrome" "<Super>c"
