git_dirty_marker="✘"
prompt_designator_symbol="➤"
prompt_designator_alternate="…"

_prompt_colour() {
  echo -n '\['
  if [[ "$1" -eq "default" ]]; then
    echo -e -n "\033[0m"
  else
    local color_number
    case "$1" in
    black) color_number=0; ;;
    red) color_number=1; ;;
    green) color_number=2; ;;
    yellow) color_number=3; ;;
    blue) color_number=4; ;;
    magenta) color_number=5; ;;
    cyan) color_number=6; ;;
    white) color_number=7; ;;
    *) color_number=9; ;;
    esac
    echo -n -e "\033[3${color_number}m"
  fi
  echo -n '\]'
}

__bash_git_branch() {
  local git_branch=$(git symbolic-ref HEAD 2> /dev/null| cut -d / -f 3)
  if [ -z "$git_branch" ]; then
    git_branch=$(git rev-parse HEAD 2> /dev/null | cut -c6)
  fi
  [[ -n "$git_branch" ]] && echo -n "on $git_branch "
}

__bash_git_dirty() {
  if [[ -n $(git status -s 2> /dev/null) ]]; then
    echo -n "$git_dirty_marker "
  fi
}

__bash_rvm_prompt_additions() {
  if [[ -x ~/.rvm/bin/rvm-prompt ]]; then
    local interpreter=$(~/.rvm/bin/rvm-prompt)
    [[ -n "$interpreter" ]] && echo -n "using $interpreter "
  fi
}

# Each part of the prompt.
_prompt_pwd="\$(_prompt_colour green)\W\$(_prompt_colour default)"
_prompt_git_branch="\$(_prompt_colour blue)\$(__bash_git_branch)\$(_prompt_colour default)"
_prompt_git_dirty="\$(_prompt_colour magenta)\$(__bash_git_dirty)\$(_prompt_colour default)"
_prompt_rvm_interpreter="\$(_prompt_colour yellow)\$(__bash_rvm_prompt_additions)\$(_prompt_colour default)"
_prompt_input_designator="\n\$(_prompt_colour green)$prompt_designator_symbol\$(_prompt_colour default) "
_prompt_input_continued="\$(_prompt_colour yellow)$prompt_designator_alternate\$(_prompt_colour default) "


PS1="${_prompt_pwd} ${_prompt_git_branch}${_prompt_rvm_interpreter}${_prompt_git_dirty}${_prompt_input_designator}"
PS2="${_prompt_input_continued}"

