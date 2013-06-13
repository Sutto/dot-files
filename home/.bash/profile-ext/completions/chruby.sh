__bash_complete_chruby() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=( $(compgen -W "$(\ls ~/.rubies)" -- $cur) )
}
complete -F __bash_complete_chruby chruby