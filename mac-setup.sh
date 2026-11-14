#!/bin/bash

# Setup script for macOS. 
#   ohmyzsh
#   homebrew
#   neovim
#   font-fira-code-nerd-font
#   vim-plug for neovim


# install ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew update
brew install neovim \
    font-fira-code-nerd-font

# Install vim-plug for neovim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
