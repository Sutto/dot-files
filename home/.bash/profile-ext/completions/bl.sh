function __bash_complete_bundle_command {
  local current
  COMPREPLY=()
  current="${COMP_WORDS[COMP_CWORD]}"
  if [[ ${COMP_CWORD} -eq 1 ]]; then
    COMPREPLY=( $(compgen -W "$(lsbundle)" -- "$current") )
  fi
}

function __bash_complete_bundle {
  local current
  local first_arg
  COMPREPLY=()
  current="${COMP_WORDS[COMP_CWORD]}"
  first_arg="${COMP_WORDS[1]}"
  if [[ ( ${COMP_CWORD} -eq 1 ) ]]; then
    COMPREPLY=( $(compgen -W "check list show outdated console open viz init gem" -- "$current") )
  elif [[ ${COMP_CWORD} -eq 2 && ( "$first_arg" -eq "open" || "$first_arg" -eq "open" ) ]]; then
    COMPREPLY=( $(compgen -W "$(lsbundle)" -- "$current") )
  fi
}

complete -F __bash_complete_bl bl

function __bash_complete_bl {
  local current
  COMPREPLY=()
  current="${COMP_WORDS[COMP_CWORD]}"
  if [[ ( ${COMP_CWORD} -eq 1 )]]; then
    COMPREPLY=( $(compgen -W "$(lsbundle)" -- "$current") )
  elif [[ ( ${COMP_CWORD} -eq 2 ) ]]; then
    COMPREPLY=( $(compgen -d -o filenames -- "$current") )
  fi
}

complete -F __bash_complete_bl bl
complete -F __bash_complete_bundle_command bo
complete -F __bash_complete_bundle_command cdbundle
complete -F __bash_complete_bundle_command cdb
complete -F __bash_complete_bundle bundle