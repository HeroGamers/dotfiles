#!/bin/bash

# Check if the script is run with sudo
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo:"
    echo "sudo $0"
    exit 1
fi

cd $HOME

# Install packages with apt

## Update and upgrade
apt -y update
apt -y upgrade

## Add software-properties-common to add ppa repositories for newer installs
apt -y install software-properties-common python3-launchpadlib

### Add repositories
#add-apt-repository ppa:neovim-ppa/stable

### Install stuff :D
apt -y install git tmux neovim fish htop ranger wget curl binutils nasm gcc-multilib g++-multilib libc6-dev-i386 libc6-dbg nmap libssl-dev libffi-dev gdb build-essential ltrace strace ruby-rubygems python3 python3-gmpy2 python3-pip python3-dev ruby-full netcat-traditional autoconf libtool automake zsh-autosuggestions zsh-syntax-highlighting zsh
# netcat => netcat-traditional     skipped libc6-dbg:i386 and lazygit

# Update Python pip packages and install needed packages
pip install --upgrade pip
pip install --upgrade capstone pyelftools==0.29 pycryptodome
pip install --upgrade --ignore-installed pwntools
pip install --upgrade ropgadget
gem install one_gadget

# Install CTF tools

## pathelf
if [ ! -d "$HOME/patchelf" ]; then
    echo "Installing pathelf..."
    cd $HOME
    git clone https://github.com/NixOS/patchelf.git
    cd $HOME/patchelf
    ./bootstrap.sh
    ./configure
    make -j$(nproc)
    make check
    make install
fi

# pwninit
if [ ! -f "/usr/local/bin/pwninit" ]; then
    echo "Installing pwninit..."
    cd /usr/local/bin
	wget https://github.com/io12/pwninit/releases/latest/download/pwninit
	chmod 755 ./pwninit
	cd $HOME
fi
