# Install and configure vim
# Reference: http://vim.wikia.com/wiki/Indenting_source_code
_basename_without_extension () {
  local file_fullname=$(basename ${1})
  local result=""
  if [[ ${file_fullname} == *.*.* ]]; then
    result=`basename "${file_fullname%.*.*}"`
  elif [[ ${file_fullname} == *.* ]]; then
    result=`basename "${file_fullname%.*}"`
  fi
  echo ${result}
}
_extract_software_2 () {
  local download_link=${1}
  target_dir=${2}
  wget ${download_link}
  local tar_file_name=`basename ${download_link}`
  tar -xvzf ${tar_file_name} -C ${target_dir}
  rm ${tar_file_name}
}

install_maven () {
  local download_link=https://dlcdn.apache.org/maven/maven-3/3.9.0/binaries/apache-maven-3.9.0-bin.tar.gz
  _extract_software_2 ${download_link} /opt/
  local extracted_package_name=`_basename_without_extension ${download_link}`
  ln -fs /opt/${extracted_package_name%-bin}/bin/mvn /usr/local/bin/mvn

}
install_vim () {
  apt-get --assume-yes install vim
  cat sudoer/templates/vimrc.local |tee /etc/vim/vimrc.local
}

# Install Google Chrome browser
install_chrome () {
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  dpkg -i google-chrome-stable_current_amd64.deb
  if [ $? -ne 0 ]; then
    # Reference: man 8 apt-get
    apt-get --assume-yes install -f
  fi
  dpkg -i google-chrome-stable_current_amd64.deb
  rm google-chrome-stable_current_amd64.deb
}

# configure_python3 () {
#  apt-get install python3-pip
#  # venv is a subset of virtualenv, so use virtualenv. Reference: https://stackoverflow.com/questions/41573587/what-is-the-difference-between-venv-pyvenv-pyenv-virtualenv-virtualenvwrappe
#  pip3 virtualenv
#}
# FAQ: 
# * How Maven compile Java source code? Answer: Maven compile source code by finding using the - javac - command in the OS

install_eclipse () {
  direct_download_link=$(python3 python/get_eclipse_package_direct_download_link.py)
  wget ${direct_download_link}
  tar_file_name=$(python3 python/utils.py get_str ${direct_download_link} ".*.tar.gz" "/")
  tar -xvzf ${tar_file_name} -C /opt/
  rm ${tar_file_name}
  # Refer to http://stackoverflow.com/questions/37864572/using-different-location-for-eclipses-p2-file
  ln -fs /opt/eclipse/eclipse /usr/bin/eclipse
  python3 python/add_to_gnome_main_menu.py eclipse /opt/eclipse/eclipse /opt/eclipse/icon.xpm
}
_add_to_gnome_main_menu () {
  local app_name=$1
  local desktop_file=/usr/share/applications/${app_name}.desktop
  cp templates/app.desktop.template $desktop_file
  sed -i "s/#{app_name}/"${app_name}"/g" $desktop_file
  sed -i "s%#{executable_file_path}%"${2}"%g" $desktop_file
  sed -i "s%#{icon_path}%"${3}"%g" $desktop_file
}
_download_intellij_idea () {
  local option=${1}
  binary_file_name=`curl -s https://www.jetbrains.com/intellij-repository/releases |grep ideaIC.zip --max-count 1 |grep -oP 'ideaIC-.*-sources.jar"' |sed 's/-sources.jar"//g'`
  tar_file_name=${binary_file_name}.tar.gz
  direct_download_link=https://download.jetbrains.com/idea/${tar_file_name}
  echo "Download IntelliJ Idea from link: "${direct_download_link}
  wget $direct_download_link
  intellij_dir=/opt/intellij
  mkdir $intellij_dir
  tar ${option} -xvzf $tar_file_name -C ${intellij_dir}/
}
install_intellij_idea () {
  _download_intellij_idea --remove-files
  local idea_bin_dir=/opt/intellij/$(sudo tar -xzvf ideaIC-2023.3.tar.gz -C /opt/intellij/ |head -n 1)bin
  ln -fs ${idea_bin_dir}/idea.sh /usr/bin/intellij.idea
  _add_to_gnome_main_menu intellij.idea ${idea_bin_dir}/idea.sh ${idea_bin_dir}/idea.png
}

install_system_monitors () {
  apt-get install strace
  apt-get install htop
}
# $1 - user to add as sudoer 
#add_sudoer () {
#  user_name=$1
#  config_statement=$(grep '^root' /etc/sudoers)
#  [[ ! $(grep '^'${user_name} /etc/sudoers) ]] && echo ${config_statement/root/$user_name} >> /etc/sudoers
#  
#}

# Reference: https://docs.docker.com/engine/install/debian/
install_docker () {
  # Set up the repository
  apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
  # Add Docker's Official GPG key
  curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg 
  echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
  apt-get update
  apt-get install docker-ce docker-ce-cli containerd.io
}
# Reference: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
install_aws_cli () {
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  ./aws/install
  rm awscliv2.zip
  rm -f aws
}

# extra
install_postfix () {
  debconf-set-selections <<< "postfix postfix/mailname string example.com"
  debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
  apt-get install -y postfix
  sed -i "s/inet_interfaces =.*$/inet_interfaces = loopback-only/" /etc/postfix/main.cf 
}

