# Import default completions
bash_completions="/Users/sutto/.rvm/scripts/completion /usr/local/Library/Contributions/brew_bash_completion.sh /usr/local/etc/bash_completion.d/* ~/.bash/completions/*.sh"
for completion in $bash_completions; do
  [[ -r "$completion" ]] && source $completion
done
