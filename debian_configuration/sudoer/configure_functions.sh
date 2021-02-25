# Install and configure vim
# Reference: http://vim.wikia.com/wiki/Indenting_source_code
function install_vim {
  apt-get --assume-yes install vim
  cat sudoer/templates/vimrc.local |tee /etc/vim/vimrc.local
}

# Install Google Chrome browser
function install_chrome {
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  dpkg -i google-chrome-stable_current_amd64.deb
  if [ $? -ne 0 ]; then
    # Reference: man 8 apt-get
    apt-get --assume-yes install -f
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

function install_eclipse {
  direct_download_link=$(python3 python/get_eclipse_package_direct_download_link.py)
  wget ${direct_download_link}
  tar_file_name=$(python3 python/utils.py get_str ${direct_download_link} ".*.tar.gz" "/")
  tar -xvzf ${tar_file_name} -C /opt/
  rm ${tar_file_name}
  # Refer to http://stackoverflow.com/questions/37864572/using-different-location-for-eclipses-p2-file
  ln -fs /opt/eclipse/eclipse /usr/bin/eclipse
  python3 python/add_to_gnome_main_menu.py eclipse /opt/eclipse/eclipse /opt/eclipse/icon.xpm
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
# $1 - user to add as sudoer 
function add_sudoer {
  user_name=$1
  config_statement=$(grep '^root' /etc/sudoers)
  [[ ! $(grep '^'${user_name} /etc/sudoers) ]] && echo ${config_statement/root/$user_name} >> /etc/sudoers
  
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

