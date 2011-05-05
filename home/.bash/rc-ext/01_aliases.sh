# All aliases for this shell.

alias bi="bundle install"
alias be="bundle exec"
alias bu="bundle update"
alias gi="git init"
alias gc="git clone"
alias gr="git remote"
alias gcom="git commit -am"

alias tunnel='ssh  -nNt -g -R :9423:0.0.0.0:3000 sutto.net'

#which -s hub && eval $(hub alias -s bash)
alias g=hub

title_is() {
  printf "\033]0;%s\007" "$1"
}

lsgems() {
  for dir in $(echo "${GEM_PATH:-"$(gem env gempath)"}" | tr ':' ' '); do
    /bin/ls $dir/gems
  done | sort | uniq
  unset dir
}

lsbundle() {
  bundle show | grep '\*' | awk '{print $2}'
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

cdbundle() {
  local item_name="$1"
  if [[ -n "$item_name" ]]; then
    local gem_path="$(bundle show "$@" 2>/dev/null)"
    local result="$?"
    [[ "$result" -gt 0 ]] && cd "$gem_path"
  fi
}
alias cdb=cdbundle

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
  git branch --set-upstream "$branch" "$remote/$branch"
}

pless() {
    pygmentize $1 | less -r
}


alias tm='mate'

rmc() {
  if [[ -s /var/run/mailcatcher.pid ]]; then
    kill `cat /var/run/mailcatcher.pid`
    rm /var/run/mailcatcher.pid
  fi
}

alias ss="r server"
alias sc="r console"
alias sp='r plugin'
alias sg='r generate'
alias sd="r dbconsole"
alias gf='git flow'
alias gff='git flow feature'

alias rr='touch tmp/restart.txt'
alias wl='tail -n0 -f log/*.log'
alias rwl='rr && wl'
alias rd='rr && touch tmp/debug.txt'
alias rdl='rd && wl'
alias pbpwd='printf "%s" "$(pwd)" | pbcopy'

alias udf='cd ~/.homesick/repos/dot-files && git pull && homesick symlink dot-files && cd - && source ~/.bash_profile'

ipv_prep() {
  rake db:drop db:migrate && rake db:seed
}

# Add the following to your ~/.bashrc or ~/.zshrc
hitch() {
  command hitch "$@"
  if [[ -s "$HOME/.hitch_export_authors" ]] ; then source "$HOME/.hitch_export_authors" ; fi
}
alias unhitch='hitch -u'
# Uncomment to persist pair info between terminal instances
# hitch

jammbox_release() {
  local last_release="$(git tag | sort | tail -1)"
  local release_number="${1:-1}"
  git checkout master &&
  git merge develop &&
  git lg "$last_release"..master &&
  git tag -a "$(date +'%Y%m%d').$(printf "%02d" "$release_number")" &&
  git push &&
  git push --tags &&
  git checkout develop
}

power() {
	cd ~/.pow
	ln -s $OLDPWD
	cd $OLDPWD
	echo "# app ENV config" > .powrc
	echo "# local ENV config" > .powenv
}