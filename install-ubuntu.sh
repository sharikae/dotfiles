#!/bin/sh

if [ ! -d "$HOME/.dotfiles" ]; then
    echo "Installing dotfiles for the first time"
    git clone --depth=1 https://github.com/sharikae/dotfiles.git "$HOME/.dotfiles"
    cd "$HOME/.dotfiles"
    [ "$1" = "ask" ] && export ASK="true"

    echo "Installing Ubuntu packages"

    sudo apt update

    sudo add-apt-repository ppa:longsleep/golang-backports

    sudo apt-get -yqq install \
        autoconf \
        build-essential \
        curl \
        fasd \
        fontconfig \
        git \
        python \
        python-setuptools \
        python-dev \
        ruby-full \
        sudo \
        tmux \
        vim \
        wget \
        zsh \
        golang \
        nodejs \
        npm

    sudo apt-get clean

    sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

    sudo npm install n -g
    sudo n stable
    sudo npm install -g yarn

    rake install
else
    echo "dotfiles is already installed"
fi

