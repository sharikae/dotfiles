#!/bin/sh

if [ ! -d "$HOME/.dotfiles" ]; then
    echo "Installing dotfiles for the first time"
    git clone --depth=1 git@github.com:sharikae/dotfiles.git "$HOME/.dotfiles"
    cd "$HOME/.dotfiles"
    [ "$1" = "ask" ] && export ASK="true"

    echo "Installing Ubuntu packages"
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
        zsh

    sudo apt-get clean

    sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

    rake install
else
    echo "dotfiles is already installed"
fi
