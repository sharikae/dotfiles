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
    curl \
    fontconfig \
    git \
    golang \
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
  sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
}

if [ ! -d "$HOME/.dotfiles" ]; then
  echo "Installing dotfiles for the first time"
  git clone --depth=1 https://github.com/sharikae/dotfiles.git "$HOME/.dotfiles"
  cd "$HOME/.dotfiles"
  [ "$1" = "ask" ] && export ASK="true"

  detect_distro
  install_packages

  rake install
else
  echo "dotfiles is already installed"
fi
