function __bash_complete_project_listing {
  local current
  COMPREPLY=()
  current="${COMP_WORDS[COMP_CWORD]}"
  if [[ ${COMP_CWORD} = 1 ]]; then
    COMPREPLY=( $(compgen -W "$(lsp)" -- "$current") )
  fi
}

function __bash_complete_lsp_options {
  COMPREPLY=()
  if [[ ${COMP_CWORD} = 1 ]]; then
    COMPREPLY=(-r)
  fi
}

complete -F __bash_complete_project_listing cdp
complete -F __bash_complete_lsp_options     lsp
