# Install CTF tools

## pwndbg
if [ ! -d "$HOME/pwndbg" ]; then
    echo "Installing pwndbg..."
    cd $HOME
    git clone https://github.com/pwndbg/pwndbg.git
    cd $HOME/pwndbg
    ./setup.sh
fi

# glibc-all-in-one
if [ ! -d "$HOME/glibc-all-in-one" ]; then
    echo "Installing glibc-all-in-one..."
    cd $HOME
    git clone https://github.com/matrix1001/glibc-all-in-one.git
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
