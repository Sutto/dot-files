# All aliases for this shell.

alias bi="bundle install --disable-shared-gems .bundle-cache"
alias be="bundle exec"
alias gi="git init"
alias gc="git clone"
alias gr="git remote"
alias gcom="git commit -am"

#which -s hub && eval $(hub alias -s bash)
alias g=hub

lsgems() {
  for dir in $(echo "${GEM_PATH:-"$(gem env gempath)"}" | tr ':' ' '); do
    /bin/ls $dir/gems
  done | sort | uniq
  unset dir
}

cdgem() {
  local gem_name="$1"
  local gem_dirs="${GEM_PATH:-"$(gem env gempath)"}"
  if [[ -z "$1" ]]; then
    cd "${GEM_HOME:-"$(gem env gemhome)"}"
    return
  fi
  for dir in $(echo "$gem_dirs" | tr ':' ' '); do
    # Get the latest version
    local full_gem_name="$(/bin/ls "$dir/gems" | grep "^$gem_name" | sort | head -n1)"
    if [[ -n "$full_gem_name" ]]; then
      cd "$dir/gems/$full_gem_name"
      return 0
    fi
  done
  echo "Unknown gem: $gem_name" 2>&1
  return 1
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

grt() {
  local remote="$2"
  local branch="$1"
  [[ -z $remote ]] && remote="origin"
  [[ -z $branch ]] && branch="master"
  git fetch "$remote"
  git config "branch.$branch.remote" "$remote"
  git config "branch.$branch.merge" "refs/heads/$branch"
}

pless() { 
    pygmentize $1 | less -r 
}


alias ss="r server"
alias sc="r console"
alias sp='r plugin'
alias sg='r generate'
alias sd="r dbconsole"

alias rr='touch tmp/restart.txt'
alias wl='tail -n0 -f log/*.log'
alias rwl='rr && wl'

alias udf='cd ~/.homesick/repos/dot-files && git pull && homesick symlink dot-files && cd - && source ~/.bash_profile'
