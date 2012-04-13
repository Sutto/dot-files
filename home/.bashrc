. ~/.bash/load-all.sh
__load_all_ext_under ~/.bash/rc-ext

# This must be the last thing / after all paths etc.
[[ -s /Users/sutto/.rvm/scripts/rvm ]] && source /Users/sutto/.rvm/scripts/rvm

# Add RVM to PATH for scripting
export PATH="$PATH:$HOME/.rvm/bin"
