function __bash_complete_cdgem {
  local current
  COMPREPLY=()
  current="${COMP_WORDS[COMP_CWORD]}"
  if [[ ( ${COMP_CWORD} -eq 1 ) && ${COMP_WORDS[0]} == cdgem ]]; then
    COMPREPLY=( $(compgen -W "$(lsgems)" -- "$current") )
  fi
}

complete -F __bash_complete_cdgem cdgem

