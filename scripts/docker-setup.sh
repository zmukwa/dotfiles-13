#!/bin/bash
set -ef -o pipefail
source "$HOME/dotfiles/scripts/helpers.sh"

if ! command -v apt-get > /dev/null; then
  echo "$XMARK Setup only supported on Ubuntu systems for now"
  exit 1
fi

# Add the Docker repo GPG key
if ! command -v docker > /dev/null; then
  echo "$ARROW Docker not installed. Adding respository (requires sudo)"
  sudo apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
  sudo add-apt-repository -y "deb https://apt.dockerproject.org/repo ${DISTRO,,}-${VERSION} main"

  echo "$ARROW Installing Docker (requires sudo)"
  sudo apt-get -q update
  sudo apt-get -qqfuy --no-install-recommends install docker-engine
fi

if [ ! -f "/etc/sudoers.d/$USER-docker" ]; then
  echo "$ARROW Allowing $USER to run docker without sudo prompt (requires sudo)"
  echo "fortes  ALL=(ALL) NOPASSWD: /usr/bin/docker" |
    sudo tee &> /dev/null "/etc/sudoers.d/$USER-docker"
fi
echo "$CMARK Sudo-less docker setup"

echo "$ARROW Checking if ufw is running (may require sudo)"
if command -v ufw > /dev/null && sudo ufw status | grep -qw active; then
  FWD_POLICY_STRING=(DEFAULT_FORWARD_POLICY="ACCEPT")
  if ! grep -qw "${FWD_POLICY_STRING[@]}"; then
    echo "$ARROW Setting" "${FWD_POLICY_STRING[@]}" "(requires sudo)"
    sudo sed -i.bak \
      's/DEFAULT_FORWARD_POLICY="[a-zA-Z]"/'.DEFAULT_FORWARD_POLICY.'/g' \
      /etc/default/ufw
    sudo rm /etc/default/ufw.bak
  fi

  echo "$ARROW Allowing incoming connections on Docker port (requires sudo)"
  sudo ufw allow 2375/tcp
  echo "$CMARK ufw rules for docker setup"
fi

echo "$CMARK Docker installed and setup"