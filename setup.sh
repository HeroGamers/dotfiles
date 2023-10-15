#!/bin/bash

# Check if the script is run with sudo
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo:"
    echo "sudo $0"
    exit 1
fi

cd $HOME

# Install packages with apt
apt -y update

apt -y upgrade
apt -y install git tmux neovim fish htop ranger wget curl binutils nasm gcc-multilib g++-multilib zsh libc6-dev-i386 libc6-dbg nmap libssl-dev libffi-dev gdb build-essential ltrace strace ruby-rubygems python3 python3-gmpy2 python3-pip python3-dev ruby-full netcat-traditional autoconf libtool automake
# netcat => netcat-traditional     skipped libc6-dbg:i386

# Update Python pip packages and install needed packages
pip install --upgrade pip
pip install --upgrade capstone pyelftools==0.29 pycryptodome
pip install --upgrade --ignore-installed pwntools
pip install --upgrade ropgadget
gem install one_gadget

# Install CTF tools

## pwndbg
if [ ! -d "$HOME/pwndbg" ]; then
    echo "Installing pwndbg..."
    cd $HOME
    git clone https://github.com/pwndbg/pwndbg.git
    cd $HOME/pwndbg
    ./setup.sh
fi

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

# Check if oh-my-zsh is already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
