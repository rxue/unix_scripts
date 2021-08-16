# reference: https://docs.docker.com/engine/install/ubuntu/
install_docker() {
  local docker_user=$1
  # Set up the repository
  #  1. Update the apt package index and install packages to allow apt to use a repository over HTTPS:
  apt-get update
  apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
  #  2. Add Docker’s official GPG key:
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  #  3. Use the following command to set up the stable repository. To add the nightly or test repository, add the word nightly or test (or both) after the word stable in the commands below.
  echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

  # Install Docker Engine
  #  Update the apt package index, and install the latest version of Docker Engine and containerd, or go to the next step to install a specific version:
  apt-get update
  apt-get install docker-ce docker-ce-cli containerd.io
  # Install docker-compose https://docs.docker.com/compose/install/
  curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
  usermod -a -G docker $docker_user
  echo "NOTE! reboot needed"
}
