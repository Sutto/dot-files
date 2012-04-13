# All aliases for this shell.

alias bi="bundle install"
alias be="bundle exec"
alias bu="bundle update"
alias gi="git init"
alias gc="git clone"
alias gr="git remote"
alias gcom="git commit -am"

alias yt="\youtube-dl -l -f 22"
alias youtube-dl="\youtube-dl -l"

# Add the following to your ~/.bashrc or ~/.zshrc
hitch() {
  command hitch "$@"
  if [[ -s "$HOME/.hitch_export_authors" ]] ; then source "$HOME/.hitch_export_authors" ; fi
}
alias unhitch='hitch -u'
# Uncomment to persist pair info between terminal instances
# hitch


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

tunnel() {
  local tunnel_port="${1:-3000}"
  echo "Tunneling port $tunnel_port locally to *.dev.filtersquad.com"
  ssh -nNt -g -R :1080:0.0.0.0:$tunnel_port jammbox
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

ss() {
  if [[ -s ./Procfile ]]; then
    if ! command -v foreman >/dev/null; then
      echo "Please run: gem install foreman"
      return 1
    fi
    foreman start
  else
    r server "$@"
  fi
  
}
alias sc="r console"
alias sp='r plugin'
alias sg='r generate'
alias sd="r dbconsole"
alias gf='git flow'
alias gff='git flow feature'

alias rr='touch tmp/restart.txt'
alias wl='mkdir -p tmp && tail -n0 -f log/*.log'
alias rwl='rr && wl'
alias rd='rr && touch tmp/debug.txt'
alias rdl='rd && wl'
alias pbpwd='printf "%s" "$(pwd)" | pbcopy'

alias udf='cd ~/.homesick/repos/dot-files && git pull && homesick symlink dot-files && cd - && source ~/.bash_profile'

jammbox_release() {
  local last_release="$(git tag | grep "^201" | sort | tail -1)"
  local supposed_next_release="$(ruby -e 'puts `git tag | grep "^201"`.split("\n").sort.last.succ')"
  local tag_prefix="$(date +'%Y%m%d')."
  if [[ "$supposed_next_release" == "$tag_prefix"* ]]; then
    local new_tag="$supposed_next_release"
  else
    local release_number="${1:-1}"
    local new_tag="${tag_prefix}$(printf "%02d" "$release_number")"
  fi
  echo "Merging develop into master" &&
  git checkout master &&
  git merge develop &&
  GIT_PAGER=cat git lg "$last_release"..master &&
  echo "Please write a tag" &&
  git tag -a "$new_tag" &&
  echo "Pushing code + tags" &&
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

disable_recent() {
  if [[ -z "$1" ]]; then
    return 1
  fi
  defaults write  "$1" NSRecentDocumentsLimit 0
  defaults delete "${1}.LSSharedFileList" RecentDocuments
  defaults write  "${1}.LSSharedFileList" RecentDocuments -dict-add MaxAmount 0
}
