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
}

# Install Google Chrome browser
function install_chrome {
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  dpkg -i google-chrome-stable_current_amd64.deb
  if [ $? -ne 0 ]; then
    # Reference: man 8 apt-get
    apt-get --asume-yes install -f
  fi
  dpkg -i google-chrome-stable_current_amd64.deb
  rm google-chrome-stable_current_amd64.deb
}

function configure_python3 {
  apt-get install python3-pip
  # venv is a subset of virtualenv, so use virtualenv. Reference: https://stackoverflow.com/questions/41573587/what-is-the-difference-between-venv-pyvenv-pyenv-virtualenv-virtualenvwrappe
  pip3 virtualenv
}
# FAQ: 
# * How Maven compile Java source code? Answer: Maven compile source code by finding using the - javac - command in the OS

# Make a keyboard shortcut to open the terminal
# @param $1 - custom name e.g. 'open Terminal' 
# @param $2 - command e.g. gnome-terminal
# @param $3 - shortcut keys e.g. "<Primary><alt>t" (Primary is ctrl)
function make_shortcut {
  custom_name=$(echo "${1}" |sed 's/ //g')
  new_keybinding="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${custom_name}/"
  existing_keybindings_val=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings |sed 's/^@as //')
  new_keybinding_val="'${new_keybinding}'"
  custom_keybindings=$(python -c 'list='"${existing_keybindings_val}"'; list.append('"${new_keybinding_val}"'); print list')
  gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "${custom_keybindings}"
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:\
${new_keybinding} name "${1}"
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:\
${new_keybinding} command "${2}"
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:\
${new_keybinding} binding "${3}"  
}

# Add program to GNOME Main Menu on system level 
# $1 - program command e.g. /usr/bin/eclipse
# $2 - program icon absolute path e.g. /opt/eclipse/eclipse.xpm
# $3 - program name
function add_program_to_gnome_main_menu {
  local _desktop_file_name="$(basename ${1})"
  local  _program_name="${3}"
  local _desktop_file_content=`cat <<EOF
[Desktop Entry]
Comment=
Terminal=false
Name=${_program_name}
Exec=${1}
Type=Application
Icon=${2}
EOF`
  echo "${_desktop_file_content}" |tee /usr/share/applications/${_desktop_file_name}.desktop
}
# Install Eclipse Neon
# This function is calling the function add_program_to_gnome_main_menu
function install_eclipse_installer {
  if [ -z "$1" ]; then
    local _installer_http_addr="https://www.eclipse.org/downloads/download.php?file=/oomph/epp/neon/R2a/eclipse-inst-linux64.tar.gz"
  fi
  local _actual_http_addr=$(wget --server-response --spider "${_installer_http_addr}" 2>&1 |grep "^Location:" |awk '{print $2}')
  wget "${_actual_http_addr}"
  tar -xvzf $(basename ${_actual_http_addr})
  rm $(basename ${_actual_http_addr})
  eclipse-installer/eclipse-inst
  # NB! When using the installer to install Eclipse IDE, turn off the "BUNDLE POOLS" on the upper righ corner of the installer GUI
  # Refer to http://stackoverflow.com/questions/37864572/using-different-location-for-eclipses-p2-file
  ln -fs /opt/eclipse/eclipse /usr/bin/eclipse
  add_program_to_gnome_main_menu /opt/eclipse/eclipse /opt/eclipse/icon.xpm "Eclipse-Neon"
}

function install_postfix {
  debconf-set-selections <<< "postfix postfix/mailname string example.com"
  debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
  apt-get install -y postfix
  sed -i "s/inet_interfaces =.*$/inet_interfaces = loopback-only/" /etc/postfix/main.cf 
}

function install_system_monitors {
  apt-get install strace
  apt-get install htop
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
# Install Docker
function install_docker {
  usermod -aG docker $USER
} 
