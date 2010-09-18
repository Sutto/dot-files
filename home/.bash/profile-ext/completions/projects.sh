function __bash_complete_project_listing {
  local current
  COMPREPLY=()
  current="${COMP_WORDS[COMP_CWORD]}"
  if [[ ${COMP_CWORD} = 1 ]]; then
    COMPREPLY=( $(__bash_lsp_with_prefix "$current") )
  else
    COMPREPLY=()
  fi
}

function __bash_complete_lsp_options {
  COMPREPLY=()
  if [[ ${COMP_CWORD} = 1 ]]; then
    COMPREPLY=(-r)
  fi
}

function __bash_lsp_with_prefix() {
  if [[ -z "$1" ]]; then
    lsp
  else
    GREP_COLORS="" lsp | grep -i "^$1"
  fi
}

complete -F __bash_complete_project_listing cdp
complete -F __bash_complete_lsp_options     lsp
