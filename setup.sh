#!/bin/bash

mkdir /usr/local/bin
cd ~

# Zinit
curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh | sh
zinit self-update

# Load starship theme
curl -sS https://starship.rs/install.sh | sh -s -- --yes # Skip prompt.
(echo 'eval "$(starship init zsh)"') >> ~/.zshrc

# Homebrew
curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | sh
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.zshrc
source ~/.zshrc

brew install --cask docker # Docker
brew install --cask rectangle # Rectangle
brew install --cask slack # Slack
brew install --cask telegram # Telegram
brew install --cask intellij-idea-ce # IntelliJ CE
brew install --cask pycharm-ce # PyCharm CE
brew install --cask sublime-text # Sublime
brew install --cask visual-studio-code # VSCODE
brew install --cask notion # Notion
brew install --cask google-chrome # Chrome
brew install --cask postman # Postman

# Set chrome as default browser
brew install defaultbrowser
defaultbrowser chrome

# Vim settings
touch ~/.vimrc & curl -X GET https://raw.githubusercontent.com/Clsan/setup/master/.vimrc >> ~/.vimrc

# Vim colorscheme
mkdir ~/.vim
mkdir ~/.vim/colors
touch ~/.vim/colors/gruvbox.vim & curl -X GET https://raw.githubusercontent.com/morhetz/gruvbox/master/colors/gruvbox.vim >> ~/.vim/colors/gruvbox.vim

# Golang
brew install golang
# GVM (Golang Version Manager)
# https://github.com/moovweb/gvm
bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
source ~/.gvm/scripts/gvm
gvm install go1.21

# NVM (Node Version Manager)
brew install nvm
mkdir ~/.nvm
echo "export NVM_DIR=\"\$([ -z \"\${XDG_CONFIG_HOME-}\" ] && printf %s \"\${HOME}/.nvm\" || printf %s \"\${XDG_CONFIG_HOME}/nvm\")\"" >> ~/.zshrc
echo "[ -s \"\$NVM_DIR/nvm.sh\" ] && \. \"\$NVM_DIR/nvm.sh\"" >> ~/.zshrc # This loads nvm

# Python
# Install pipx
brew install pipx
pipx ensurepath
sudo pipx ensurepath --global
# Install pyenv (Python version manager)
brew install pyenv
# Install poetry 
pipx install poetry

# Java
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install java 17.0.2.8.1-amzn
sdk install java 8.0.412-amzn
sdk install gradle 8.7

# AWS
brew install awscli # Awscli

# ETC
brew install tree
brew install vegeta

# Enable zsh
zsh
