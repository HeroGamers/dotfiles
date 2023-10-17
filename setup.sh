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

# Other customizations

## TPM (tmux plugin manager)
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "Installing TPM..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

## NVchad
if [ ! -d "$HOME/.config/nvim/lua/core" ]; then
    echo "Installing NVChad..."
	mkdir ~/tmp
	mv ~/.config/nvim/lua/custom ~/tmp/nvim_custom
    git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
	mv ~/tmp/nvim_custom ~/.config/nvim/lua/custom
fi

## oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing oh-my-zsh..."
    # We want to keep zshrc and run it unattended
    KEEP_ZSHRC=yes
    RUNZSH=no
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
fi

## zsh dependencies

### powerlevel10k theme
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo "Downloading powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

### Fast syntax highlighting
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/F-Sy-H" ]; then
    echo "Downloading fast-syntax-highlighting..."
    git clone https://github.com/z-shell/F-Sy-H.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/F-Sy-H
fi

### Autocomplete
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autocomplete" ]; then
    echo "Downloading zsh-autocomplete..."
    git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autocomplete
fi

### Autosuggest
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    echo "Downloading zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi
