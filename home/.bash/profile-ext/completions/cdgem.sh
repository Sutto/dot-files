function __bash_complete_cdgem {
  local current
  COMPREPLY=()
  current="${COMP_WORDS[COMP_CWORD]}"
  if [[ ( ${COMP_CWORD} -eq 1 ) && ${COMP_WORDS[0]} == cdgem ]]; then
    COMPREPLY=( $(compgen -W "$(lsgems)" -- "$current") )
  fi
}

function __bash_complete_cdbundle {
  local current
  COMPREPLY=()
  current="${COMP_WORDS[COMP_CWORD]}"
  if [[ ( ${COMP_CWORD} -eq 1 ) ]] && [[ ${COMP_WORDS[0]} == cdbundle || ${COMP_WORDS[0]} == cdb ]]; then
    COMPREPLY=( $(compgen -W "$(lsbundle)" -- "$current") )
  fi
}

complete -F __bash_complete_cdgem    cdgem
complete -F __bash_complete_cdbundle cdbundle
complete -F __bash_complete_cdbundle cdb

