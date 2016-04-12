shopt -s checkwinsize

source ~/.bash/load-all.sh
__load_all_ext_under ~/.bash/profile-ext

source ~/.bashrc

command -v load_all_completions > /dev/null && load_all_completions

export NVM_DIR=~/.nvm
  source $(brew --prefix nvm)/nvm.sh

