GIT_PS1_SHOWDIRTYSTATE=1

function __pc {
  ~/.rvm/scripts/color "$1"
}

function __bash_git_branch {
  local git_dir=$(git rev-parse --git-dir 2>/dev/null)
  [[ -z "$git_dir" ]] && return 0
  
  local git_branch=$(git symbolic-ref HEAD 2>/dev/null| cut -d / -f 3)
  
  if [[ -z "$git_branch" ]]; then
    local git_branch=$(git log HEAD^..HEAD --pretty=format:%h | head -1 2>/dev/null)
  fi
  
  echo -n "$git_branch "
}

function __bash_git_dirty {
  local git_dir=$(git rev-parse --git-dir 2>/dev/null)
  [[ -z "$git_dir" ]] && return 0
  
  if [[ ! -z $(git status | grep 'added to commit' 2> /dev/null) ]]; then
    echo -n "(!) "  
  fi 

}

function __bash_pwd_prompt_additions {
  if [[ "$PWD" = ~ ]]; then
    echo -n '~'
  else
    basename "$PWD"
  fi
}

function __bash_rvm_prompt_additions {
  if [[ -r ~/.rvm/bin/rvm-prompt ]]; then
    local interpreter=$(~/.rvm/bin/rvm-prompt u)
    if [[ ! -z "$interpreter" ]]; then
      echo -n "$interpreter "
    fi
  fi
}

# Each part of the prompt.
_prompt_pwd="\[\$(__pc green)\]\$(__bash_pwd_prompt_additions)\[\$(__pc default)\]"
_prompt_git_branch="\[\$(__pc blue)\]\$(__bash_git_branch)\[\$(__pc default)\]"
_prompt_git_dirty="\[\$(__pc magenta)\]\$(__bash_git_dirty)\[\$(__pc default)\]"
_prompt_rvm_interpreter="\[\$(__pc yellow)\]\$(__bash_rvm_prompt_additions)\[\$(__pc default)\]"

PS1="${_prompt_rvm_interpreter}${_prompt_pwd} ${_prompt_git_branch}${_prompt_git_dirty}\\$ "
