#!/bin/bash

cd ~

# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

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

# Shiftit
brew install --cask shiftit

# NVM (Node Version Manager)
brew install nvm
mkdir ~/.nvm
echo "export NVM_DIR=\"$HOME/.nvm\"" >> ~/.zshrc
echo "[ -s \"/usr/local/opt/nvm/nvm.sh\" ] && . \"/usr/local/opt/nvm/nvm.sh\"  # This loads nvm" >> ~/.zshrc
echo "[ -s \"/usr/local/opt/nvm/etc/bash_completion\" ] && . \"/usr/local/opt/nvm/etc/bash_completion\"  # This loads nvm bash_completion" >> ~/.zshrc

# Python
brew install pipenv

# Enable zsh
zsh
