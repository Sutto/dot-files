git_dirty_marker="♼ "

__pc() {
  ~/.rvm/scripts/color "$1"
}

_prompt_colour() {
  echo -n '\['
  if [[ "$1" -eq "default" ]]; then
    echo -e -n "\033[0m"
  else
    local color_number
    case "$1" in
    green)
    color_number=2;
    ;;
    blue)
    color_number=4;
    ;;
    magenta)
    color_number=5;
    ;;
    yellow)
    color_number=3;
    ;;
    *)
    color_number=9;
    ;;
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
_prompt_pwd="\$(_prompt_color green)\W\[\$(__pc default)\]"
_prompt_git_branch="\[\$(__pc blue)\]\$(__bash_git_branch)\[\$(__pc default)\]"
_prompt_git_dirty="\[\$(__pc magenta)\]\$(__bash_git_dirty)\[\$(__pc default)\]"
_prompt_rvm_interpreter="\[\$(__pc yellow)\]\$(__bash_rvm_prompt_additions)\[\$(__pc default)\]"

PS1="${_prompt_pwd} ${_prompt_git_branch}${_prompt_rvm_interpreter}${_prompt_git_dirty}\n\\$ "
