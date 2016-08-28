#!/bin/bash
# Install and configure vim
# Reference: http://vim.wikia.com/wiki/Indenting_source_code
function install_vim {
  sudo apt-get install vim
  config_statements=`cat <<EOF
set number
syntax on
set hlsearch
set expandtab
set shiftwidth=2
set softtabstop=2
EOF`
  echo "${config_statements}" |tee ${HOME}/.vimrc
  echo "${config_statements}" |sudo tee /root/.vimrc
  # set vim as the default editor of git
  git config --global core.editor "vim"
}
# Make a keyboard shortcut to open the terminal
# @param $1 - custom name e.g. 'open terminal' 
# @param $2 - command e.g. program
# @param $3 - shortcut keys e.g. <ctrl><alt>t
function make_shortcut {
  custom_name=$(echo "${1}" |sed 's/ //g')
  existing_bindings=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)
  if [[ "${existing_bindings}" = *"[]" ]]; then
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings \
"['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${custom_name}/']"
  else
    existing_bindings=$(sed "s/]/,'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/"${custom_name}"/']" \
<<< "${existing_bindings}")
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "${existing_bindings}"
  fi
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:\
/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${custom_name}/ name "${1}"
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:\
/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${custom_name}/ command "${2}"
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:\
/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${custom_name}/ binding "${3}"  
}

# Install Chrome
function install_chrome {
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo dpkg -i google-chrome-stable_current_amd64.deb
  if [ $? -ne 0 ]; then
    sudo apt-get install -f
  fi
  sudo dpkg -i google-chrome-stable_current_amd64.deb
  rm google-chrome-stable_current_amd64.deb
}

# Add ibus Chinese input method
function install_chinese_im {
  if [ "${1}" = "ibus" ]; then
    sudo apt-get install ibus ibus-libpinyin
    sudo gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'fi'), ('ibus', 'libpinyin')]"
  elif [ "${1}" = "sogoupinyin" ]; then
    #Set only Finnish as the input-sources
    gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'fi')]"
    sudo apt-get install fcitx fcitx-googlepinyin
    download_address=$(wget --server-response --spider "http://pinyin.sogou.com/linux/download.php?f=linux&bit=64" \
2>&1 | grep "^  Location" |awk '{print $2}')
    file_name=$(expr match "$download_address" '.*\(fn=.*\)' |awk -F "=" '{print $NF}')
    wget $download_address -O $file_name
    sudo dpkg -i $file_name
    if [ $? -ne 0]; then
      sudo apt-get install -f
      sudo dpkg -i $file_name
    fi
    rm $file_name
  fi
}
# Install Skype
function install_skype {
  location_str=$(wget --server-response --spider https://get.skype.com/go/getskype-linux-deb-32 2>&1 \
|grep "^  Location")
  download_url=$(python -c 'print "'"${location_str}"'".split()[-1]')
  wget ${donwlo_url}
  sudo dpkg --add-architecture i386
  sudo apt-get update
  sudo dpkg -i $(basename ${download_url})
  sudo apt-get install -f
  sudo dpkg -i $(basename ${download_url})
}
# Install Java 8 from openjdk
# Reference: https://www.linkedin.com/pulse/installing-openjdk-8-tomcat-debian-jessie-iga-made-muliarsa
function install_openjdk8 {
  echo "deb http://ftp.de.debian.org/debian jessie-backports main" |sudo tee -a /etc/apt/sources.list
  sudo apt-get update
  sudo apt-get install openjdk-8-jdk
  sudo ln -f -s /usr/lib/jvm/java-1.8.0-openjdk-amd64/jre/man/man1/java.1.gz /etc/alternatives/java.1.gz
  sudo ln -f -s /usr/lib/jvm/java-1.8.0-openjdk-amd64/jre/bin/java /etc/alternatives/java
}

# Install Eclipse Neon
function install_eclipse_neon_installer {
  wget http://mirror.dkm.cz/eclipse/oomph/epp/neon/R/eclipse-inst-linux64.tar.gz
  sudo tar -xvzf eclipse-inst-linux64.tar.gz --directory /opt
  rm eclipse-inst*
  # http://stackoverflow.com/questions/37864572/using-different-location-for-eclipses-p2-file
}

# Add program to GNOME Main Menu 
# $1 - program command e.g. /usr/bin/eclipse
# $2 - program icon absolute path
# $3 - program name
function add_program_to_gnome_main_menu {
  if [ -z "${3}" ]; then
    program_name=$(basename ${1})
    desktop_file_name=${program_name}
  else
    # Inline Python
    desktop_file_name=$(python -c 'print "'"${3}"'".replace(" ", "-")')
    desktop_file_name=$(python -c 'print "'"${desktop_file_name}"'".lower()')
    program_name="${3}"
  fi
  echo "[Desktop Entry]" > ~/.local/share/applications/${desktop_file_name}.desktop
  echo "Comment=" >> ~/.local/share/applications/${desktop_file_name}.desktop
  echo "Terminal=false" >> ~/.local/share/applications/${desktop_file_name}.desktop
  echo "Name=${program_name}" >> ~/.local/share/applications/${desktop_file_name}.desktop
  echo "Exec=${1}" >> ~/.local/share/applications/${desktop_file_name}.desktop
  echo "Type=Application" >> ~/.local/share/applications/${desktop_file_name}.desktop
  echo "Icon=${2}" >> ~/.local/share/applications/${desktop_file_name}.desktop
}
