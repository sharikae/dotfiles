#!/bin/bash

set -e

# Detect OS distribution
detect_distro() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO="$ID"
    DISTRO_VERSION="$VERSION_ID"
  elif command -v lsb_release > /dev/null 2>&1; then
    DISTRO=$(lsb_release -si | tr '[:upper:]' '[:lower:]')
    DISTRO_VERSION=$(lsb_release -sr)
  else
    echo "Error: Cannot detect Linux distribution."
    exit 1
  fi
}

install_packages() {
  echo "======================================================"
  echo "Detected: $DISTRO $DISTRO_VERSION"
  echo "======================================================"

  sudo apt-get update

  # Ubuntu-specific: add universe repository if needed
  if [ "$DISTRO" = "ubuntu" ]; then
    sudo apt-get install -yqq software-properties-common
    sudo add-apt-repository -y universe
    sudo apt-get update
  fi

  sudo apt-get install -yqq \
    autoconf \
    build-essential \
    ca-certificates \
    curl \
    fontconfig \
    git \
    gnupg \
    nodejs \
    npm \
    python3 \
    python3-setuptools \
    python3-dev \
    ruby-full \
    sudo \
    tmux \
    vim \
    wget \
    zsh

  sudo apt-get clean
}

install_go() {
  echo "======================================================"
  echo "Installing latest Go"
  echo "======================================================"

  local go_version
  go_version=$(curl -fsSL https://go.dev/VERSION?m=text | head -1)
  echo "  version: $go_version"

  curl -fsSL "https://go.dev/dl/${go_version}.linux-$(dpkg --print-architecture).tar.gz" -o /tmp/go.tar.gz
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf /tmp/go.tar.gz
  rm /tmp/go.tar.gz

  export PATH="/usr/local/go/bin:$HOME/go/bin:$PATH"
  go version
}

install_ghq() {
  echo "======================================================"
  echo "Installing ghq"
  echo "======================================================"

  export PATH="/usr/local/go/bin:$HOME/go/bin:$PATH"
  go install github.com/x-motemen/ghq@latest
  ghq --version
}

install_docker() {
  echo "======================================================"
  echo "Installing Docker CE"
  echo "======================================================"

  if command -v docker > /dev/null 2>&1; then
    echo "  Docker already installed: $(docker --version)"
    return
  fi

  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL "https://download.docker.com/linux/${DISTRO}/gpg" | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg

  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/${DISTRO} $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
    | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt-get update -qq
  sudo apt-get install -yqq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  sudo usermod -aG docker "$USER"
  echo "  $(docker --version)"
}

install_gh_cli() {
  echo "======================================================"
  echo "Installing GitHub CLI"
  echo "======================================================"

  if command -v gh > /dev/null 2>&1; then
    echo "  gh already installed: $(gh --version | head -1)"
    return
  fi

  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg 2>/dev/null
  sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg

  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

  sudo apt-get update -qq
  sudo apt-get install -yqq gh
  echo "  $(gh --version | head -1)"
}

setup_ssh_key() {
  echo "======================================================"
  echo "Setting up SSH key"
  echo "======================================================"

  if [ -f "$HOME/.ssh/id_ed25519" ]; then
    echo "  SSH key already exists, skipping"
    return
  fi

  local email
  email=$(git config --global user.email 2>/dev/null || true)
  if [ -z "$email" ]; then
    echo -n "  Enter your email for SSH key: "
    read -r email
  fi

  ssh-keygen -t ed25519 -C "$email" -f "$HOME/.ssh/id_ed25519" -N ""
  echo "  Key generated: $(cat "$HOME/.ssh/id_ed25519.pub")"
  echo ""
  echo "  Register this key on GitHub:"
  echo "    gh ssh-key add ~/.ssh/id_ed25519.pub --title \"$(hostname)\""
}

if [ ! -d "$HOME/.dotfiles" ]; then
  echo "Installing dotfiles for the first time"
  git clone --depth=1 https://github.com/sharikae/dotfiles.git "$HOME/.dotfiles"
  cd "$HOME/.dotfiles"
  [ "$1" = "ask" ] && export ASK="true"

  detect_distro
  install_packages
  install_go
  install_docker
  install_gh_cli
  install_ghq

  rake install

  setup_ssh_key

  echo ""
  echo "======================================================"
  echo "Setup complete!"
  echo "======================================================"
  echo ""
  echo "Manual steps remaining:"
  echo "  1. gh auth login"
  echo "  2. gh ssh-key add ~/.ssh/id_ed25519.pub --title \"$(hostname)\""
  echo "  3. Log out and back in for docker group to take effect"
  echo ""
else
  echo "dotfiles is already installed"
fi
