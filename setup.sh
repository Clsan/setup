#!/bin/bash

cd ~

touch ~/.zshrc

# Zinit
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
zsh
zinit self-update

# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.zshrc
zsh

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

# Set chrome as default browser
brew install defaultbrowser
defaultbrowser chrome

# Vim settings
touch ~/.vimrc & curl -X GET https://raw.githubusercontent.com/Clsan/setup/master/.vimrc >> ~/.vimrc

# Vim colorscheme
mkdir ~/.vim
mkdir ~/.vim/colors
touch ~/.vim/colors/gruvbox.vim & curl -X GET https://raw.githubusercontent.com/morhetz/gruvbox/master/colors/gruvbox.vim >> ~/.vim/colors/gruvbox.vim

# GVM (Golang Version Manager)
# https://github.com/moovweb/gvm
bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
source /Users/clsan/.gvm/scripts/gvm
gvm install go1.21

# NVM (Node Version Manager)
brew install nvm
mkdir ~/.nvm
echo "export NVM_DIR=\"$HOME/.nvm\"" >> ~/.zshrc
echo "[ -s \"/usr/local/opt/nvm/nvm.sh\" ] && . \"/usr/local/opt/nvm/nvm.sh\"  # This loads nvm" >> ~/.zshrc
echo "[ -s \"/usr/local/opt/nvm/etc/bash_completion\" ] && . \"/usr/local/opt/nvm/etc/bash_completion\"  # This loads nvm bash_completion" >> ~/.zshrc

# Python
brew install pyenv
brew install pipenv

brew install golang # Golang
brew install awscli # Awscli

# Java
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install java 17.0.2.8.1-amzn
sdk install java 8.322.06.2-amzn
sdk install gradle 7.3.3

# ETC
brew install tree
brew install vegeta

# Enable zsh
zsh
