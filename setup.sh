#!/bin/bash

cd ~

# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"


# Install function
function install_dmg() {
    local value=$1
    echo "Installing $value"
    local volume=$(hdiutil attach "$value" | tail -1 | awk '{$1=$2=""; gsub(/^ +/,"",$0); print $0}')
    cp -r "$volume/"*.app /Applications/
    diskutil unmount "$volume"
	rm -rf "$value"
    echo "Done installig $value"
}

# Telegram
curl -L https://telegram.org/dl/macos > ~/Downloads/telegram.dmg
install_dmg ~/Downloads/telegram.dmg

# Sublime
curl -L https://download.sublimetext.com/Sublime%20Text%20Build%203211.dmg > ~/Downloads/sublime.dmg
install_dmg ~/Downloads/sublime.dmg

# VSCODE
curl -L https://code.visualstudio.com/sha/download?build=stable&os=darwin-universal > ~/Downloads/vscode.zip
unzip ~/Downloads/vscode.zip
mv ~/Visual\ Studio\ Code.app /Applications/Visual\ Studio\ Code.app
rm -rf ~/Downloads/vscode.zip

# Chrome
curl -L https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg > ~/Downloads/chrome.dmg
install_dmg ~/Downloads/chrome.dmg
brew install defaultbrowser
defaultbrowser chrome

# Notion
curl -L https://www.notion.so/desktop/mac/download > ~/Downloads/notion.dmg
install_dmg ~/Downloads/notion.dmg

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

# Enable zsh
zsh
