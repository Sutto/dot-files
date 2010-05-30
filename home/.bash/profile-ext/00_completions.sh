# Import default completions
bash_completions=(~/.rvm/scripts/completion /usr/local/Library/Contributions/brew_bash_completion.sh /usr/local/etc/bash_completion.d/* ~/.bash/profile-ext/completions/*.sh)
for completion in ${bash_completions[*]}; do
  [[ -r $completion ]] && source $completion
done

