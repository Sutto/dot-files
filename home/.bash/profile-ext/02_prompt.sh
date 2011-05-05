vc_dirty_marker="✘"
prompt_designator_symbol="»"
prompt_designator_alternate="…"

_prompt_colour() {
  echo -n '\['
  if [[ "$1" = default ]]; then
    echo -n "\\e[0m"
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
    echo -n "\\e[3${color_number}m"
  fi
  echo -n '\]'
}

__bash_vcprompt_on() {
  local vcprompt_value="$(/usr/local/bin/vcprompt -f "%b")"
  [[ -n "$vcprompt_value" ]] && echo -n "on $vcprompt_value "
}

__bash_vcprompt_dirty() {
  local vcprompt_status="$(/usr/local/bin/vcprompt -f "%m")"
  if [[ -n "$vcprompt_status" && "$vcprompt_status" != "clean" ]]; then
    echo -n "$vc_dirty_marker "
  fi
}

__bash_rvm_prompt_additions() {
  if [[ -x ~/.rvm/bin/rvm-prompt ]]; then
    local interpreter="$(~/.rvm/bin/rvm-prompt)"
    [[ -n "$interpreter" ]] && echo -n "using $interpreter "
  fi
}

# Each part of the prompt.
_prompt_pwd="$(_prompt_colour green)\W$(_prompt_colour default)"
_prompt_git_branch="$(_prompt_colour blue)\$(__bash_vcprompt_on)$(_prompt_colour default)"
_prompt_git_dirty="$(_prompt_colour magenta)\$(__bash_vcprompt_dirty)$(_prompt_colour default)"
_prompt_rvm_interpreter="$(_prompt_colour yellow)\$(__bash_rvm_prompt_additions)$(_prompt_colour default)"
_prompt_input_designator="\n$(_prompt_colour red)$prompt_designator_symbol$(_prompt_colour default) "
_prompt_input_continued="$(_prompt_colour yellow)$prompt_designator_alternate$(_prompt_colour default) "

_stty_reset="$(stty echo)"

PS1="${_stty_reset}${_prompt_pwd} ${_prompt_git_branch}${_prompt_rvm_interpreter}${_prompt_git_dirty}${_prompt_input_designator}"
PS2="${_stty_reset}${_prompt_input_continued}"

