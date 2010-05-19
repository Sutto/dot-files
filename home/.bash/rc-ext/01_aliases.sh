# All aliases for this shell.

alias bi="bundle install --disable-shared-gems .bundle-cache"
alias be="bundle exec"
alias gi="git init"
alias gc="git clone"
alias gr="git remote"
alias gcom="git commit -am"

which -s hub && eval $(hub alias -s bash)


# Changes into the directory for a given gem.
cdgem() {
  local gem_name="$1"
  local gem_dir="$GEM_HOME"
  if [[ -z "$gem_dir" ]]; then
    local gem_dir=$(gem env gemdir)
  fi
  local full_gem_path="$gem_dir/gems/$gem_name"
  if [[ -d "$full_gem_path" ]]; then
    cd "$full_gem_path"
  else
    echo "Unknown gem: $gem_name" 2>&1
    return 1
  fi
}

rails_version() {
  which -s rails && rails -v 2>/dev/null | sed 's/Rails //'
}

r() {
  local name="$1"
  shift
  if [[ -z "$name" ]]; then
    echo "Usage: $0 command *args" >&2
    return 1
  fi
  if [[ -x "./script/$name" ]]; then
    ./script/$name $@
  elif [[ -x "./script/rails" ]]; then
    ./script/rails "$name" $@
  elif [[ -n "$(rails_version | grep '^3')" ]]; then
    rails "$name" $@
  else
    echo "Please change to the root of your project first." >&2
    return 1
  fi

}

alias ss="r server"
alias sc="r console"
alias sp='r plugin'
alias sg='r generate'
alias sd="r dbconsole"

alias rr='touch tmp/restart.txt'
alias wl='tail -f log/*.log'
alias rwl='rr && wl'

alias udf='cd ~/.homesick/repos/dot-files && git pull && homesick symlink dot-files && cd - && source ~/.bash_profile'
