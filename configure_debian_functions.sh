# Install and configure vim
# Reference: http://vim.wikia.com/wiki/Indenting_source_code
function install_vim {
  apt-get install vim
  # Reference: http://tldp.org/LDP/abs/html/here-docs.html
  #Configure VIM on the system level
  config_statements=`cat <<EOF
set number
syntax on
set hlsearch
set expandtab
set shiftwidth=2
set softtabstop=2
EOF`
  echo "${config_statements}" |tee /etc/vim/vimrc.local
  # set vim as the default editor of git
  git config --global core.editor "vim"
}
# Install Java 8 from openjdk
# Reference: https://www.linkedin.com/pulse/installing-openjdk-8-tomcat-debian-jessie-iga-made-muliarsa
function install_openjdk8 {
  local _deb_dist_component_str="deb http://ftp.de.debian.org/debian jessie-backports main"
  if [ -z "`grep "${_deb_dist_component_str}" /etc/apt/sources.list`" ]; then 
    echo "${_deb_dist_component_str}" >> /etc/apt/sources.list 
  fi
  apt-get update
  apt-get install openjdk-8-jdk
  #openjdk-8 is installed to directory /usr/lib/jvm/java-1.8.0-openjdk-amd64
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
  dpkg -i google-chrome-stable_current_amd64.deb
  if [ $? -ne 0 ]; then
    apt-get install -f
  fi
  dpkg -i google-chrome-stable_current_amd64.deb
  rm google-chrome-stable_current_amd64.deb
}

# Add ibus Chinese input method
function install_chinese_im {
  if [ "${1}" = "ibus" ]; then
    apt-get install ibus ibus-libpinyin
    gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'fi'), ('ibus', 'libpinyin')]"
  elif [ "${1}" = "sogoupinyin" ]; then
    #Set only Finnish as the input-sources
    gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'fi')]"
    apt-get install fcitx fcitx-googlepinyin
    download_address=$(wget --server-response --spider "http://pinyin.sogou.com/linux/download.php?f=linux&bit=64" \
2>&1 | grep "^  Location" |awk '{print $2}')
    file_name=$(expr match "$download_address" '.*\(fn=.*\)' |awk -F "=" '{print $NF}')
    wget $download_address -O $file_name
    dpkg -i $file_name
    if [ $? -ne 0]; then
      apt-get install -f
      dpkg -i $file_name
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
  dpkg --add-architecture i386
  apt-get update
  dpkg -i $(basename ${download_url})
  apt-get install -f
  dpkg -i $(basename ${download_url})
}

# Install Eclipse Neon
function install_eclipse_installer {
  if [ -z "$1" ]; then
    local _installer_http_addr="https://www.eclipse.org/downloads/download.php?file=/oomph/epp/neon/R2a/eclipse-inst-linux64.tar.gz"
  fi
  local _actual_http_addr=$(wget --server-response --spider "${_installer_http_addr}" 2>&1 |grep "^Location:" |awk '{print $2}')
  wget "${_actual_http_addr}"
  tar -xvzf $(basename ${_actual_http_addr})
  rm $(basename ${_actual_http_addr})
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

function install_postfix {
  debconf-set-selections <<< "postfix postfix/mailname string example.com"
  debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
  apt-get install -y postfix
  sed -i "s/inet_interfaces =.*$/inet_interfaces = loopbak-only/" /etc/postfix/main.cf 
}
function install_system_monitors {
  apt-get install strace
  apt-get install htop
}
