#!/bin/bash
apt-get -y install sudo
apt-get update
# install Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
while ! dpkg -i google-chrome-stable_current_amd64.deb; do
  apt-get -f install
done
# add ibus Chinese input method
install_chinese_im() {
  if [ "${1}" = "ibus" ]; then
    apt-get install ibus
    apt-get install ibus-pinyin
    gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'fi'), ('xkb', 'us'), ('ibus', 'pinyin')]"
  elif [ "${1}" = "sogoupinyin" ]; then
    apt-get install fcitx
    download_address=$(wget --server-response --spider "http://pinyin.sogou.com/linux/download.php?f=linux&bit=64" 2>&1 |grep "^  Location" |awk '{print $2}')
    file_name=$(echo $download_address |awk "=" '{print $NF}')
  fi
}

# install Java 8
wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u92-b14/jdk-8u92-linux-x64.tar.gz
## ref: http://www.tldp.org/LDP/Linux-Filesystem-Hierarchy/html/usr.html 
tar xvzf jdk-8u92-linux-x64.tar.gz -C /usr/lib/jvm
rm jdk-8u92-linux-x64.tar.gz
ln -sf /usr/lib/jvm/jdk1.8.0_92/jre/bin/java /etc/alternatives/java 
ln -s /usr/lib/jvm/jdk1.8.0_92 /usr/lib/jvm/java-8-jdk-amd64
ln -sf /usr/lib/jvm/java-8-jdk-amd64 /usr/lib/jvm/default-java
wget http://eclipse.mirror.garr.it/mirrors/eclipse//oomph/epp/neon/R/eclipse-inst-linux64.tar.gz
tar xvzf eclipse-inst-linux64.tar.gz -C /usr/lib/
rm eclipse-inst-linux64.tar.gz
# Install Eclipse Che
## Install Docker. ref: https://docs.docker.com/engine/installation/linux/debian/
apt-get purge lxc-docker*
apt-get purge docker.io*
apt-get update
apt-get install apt-transport-https ca-certificates
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo debian-jessie main" > /etc/apt/sources.list.d/docker.list
apt-get update
apt-cache policy docker-engine
apt-get update
apt-get install docker-engine
service docker start
docker run hello-world
user_1000=`getent passwd 1000 |cut -d':' -f1`
runuser -l ${user_1000} -c 'wget http://ftp.fau.de/eclipse/che/eclipse-che-4.0.1.zip'
gpasswd -a ${user_1000} docker
chmod 777 /var/run/docker.sock
echo "export JAVA_HOME=/usr/lib/jvm/jdk1.8.0_92/jre" > /etc/profile.d/custom.sh
