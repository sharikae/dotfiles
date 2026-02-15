FROM ubuntu:24.04
LABEL maintainer="sharikae"

# Let the container know that there is no tty
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm-256color

# Bootstrapping packages needed for installation
RUN \
  apt-get update && \
  apt-get install -yqq \
    locales \
    lsb-release \
    software-properties-common && \
  apt-get clean

# Set locale to UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
RUN localedef -i en_US -f UTF-8 en_US.UTF-8 && \
  /usr/sbin/update-locale LANG=$LANG

# Install dependencies
RUN \
  apt-get update && \
  apt-get -yqq install \
    autoconf \
    build-essential \
    curl \
    fontconfig \
    git \
    python3 \
    python3-setuptools \
    python3-dev \
    ruby-full \
    sudo \
    tmux \
    vim \
    wget \
    zsh && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install dotfiles
COPY . /root/.dotfiles
RUN cd /root/.dotfiles && rake install

# Run a zsh session
CMD [ "/bin/zsh" ]
