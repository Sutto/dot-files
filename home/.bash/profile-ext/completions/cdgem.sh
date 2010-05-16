function __bash_complete_cdgem {
  local current gem_dir gem_list
  COMPREPLY=()
  current="${COMP_WORDS[COMP_CWORD]}"
  if [[ ( ${COMP_CWORD} -eq 1 ) && ${COMP_WORDS[0]} == cdgem ]]; then
    gem_dir="$GEM_HOME"
    if [[ -z "$gem_dir" ]]; then
      gem_dir=$(gem env gemdir)
    fi
    gem_list=$(ls "$gem_dir/gems/")
    COMPREPLY=( $(compgen -W "$gem_list" -- "$current") )
  fi
}

complete -F __bash_complete_cdgem cdgem

