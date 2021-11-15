#!/bin/bash

cd ~

# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

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

# Oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Additional zsh settings
rm -rf ~/.zshrc
touch ~/.zshrc & curl -X GET https://raw.githubusercontent.com/Clsan/setup/master/.zshrc >> ~/.zshrc

# Vim settings
touch ~/.vimrc & curl -X GET https://raw.githubusercontent.com/Clsan/setup/master/.vimrc >> ~/.vimrc

# Vim colorscheme
mkdir ~/.vim
mkdir ~/.vim/colors
touch ~/.vim/colors/gruvbox.vim & curl -X GET https://raw.githubusercontent.com/morhetz/gruvbox/master/colors/gruvbox.vim >> ~/.vim/colors/gruvbox.vim

brew install --cask shiftit # Shiftit
brew install --cask docker # Docker

# NVM (Node Version Manager)
brew install nvm
mkdir ~/.nvm
echo "export NVM_DIR=\"$HOME/.nvm\"" >> ~/.zshrc
echo "[ -s \"/usr/local/opt/nvm/nvm.sh\" ] && . \"/usr/local/opt/nvm/nvm.sh\"  # This loads nvm" >> ~/.zshrc
echo "[ -s \"/usr/local/opt/nvm/etc/bash_completion\" ] && . \"/usr/local/opt/nvm/etc/bash_completion\"  # This loads nvm bash_completion" >> ~/.zshrc

brew install pipenv # Python
brew install golang # Golang
brew install awscli # Awscli

# Java
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install java 11.0.11.j9-adpt
sdk install gradle 6.8.3

# Enable zsh
zsh
