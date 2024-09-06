pwd
touch ~/.zshrc
curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh | NO_INPUT=true sh
cat ~/.zshrc
source ~/.zshrc
zinit self-update