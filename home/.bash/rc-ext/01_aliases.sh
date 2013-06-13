# All aliases for this shell.

alias bi="bundle install"
alias be="bundle exec"
alias bu="bundle update"

alias yt="\youtube-dl -l -f 22"
alias youtube-dl="\youtube-dl -l"

bl() {
  # bundle list --no-color | awk '{print $2}' | tail -n +2
  if [[ -z "$1" ]]; then
    echo "Usage: bl gem-name directory" >&2
    return 1
  fi

  if [[ -z "$2" || ! -d "$2" ]]; then
    echo "Please ensure a dir is provided" >&2
    return 2
  fi

  bundle config --local "local.$1" "$2"
}

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
  bundle show --no-color | grep '\*' | awk '{print $2}'
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
  else
    rails "$name" $@
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
  r server "$@"
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

disable_recent() {
  if [[ -z "$1" ]]; then
    return 1
  fi
  defaults write  "$1" NSRecentDocumentsLimit 0
  defaults delete "${1}.LSSharedFileList" RecentDocuments
  defaults write  "${1}.LSSharedFileList" RecentDocuments -dict-add MaxAmount 0
}

mediakeys() {
  if [[ -z "$1" || "$1" == "disable" ]]; then
    echo "Disabling the RCD agent"
    launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist
  else
    echo "Loading the RCD agent"
    launchctl load -w /System/Library/LaunchAgents/com.apple.rcd.plist
  fi
}

pr() {
  identifier="$(hub pull-request)"
  if [[ "$?" != 0 ]]; then
    echo "Cancelled Pull Request."
    return 1
  fi
  echo "$identifier" | pbcopy
  open "$identifier"
}

gifify() {
  if [[ -n "$1" ]]; then
    if [[ $2 == '--good' ]]; then
      ffmpeg -i $1 -r 10 -vcodec png out-static-%05d.png
      time convert -verbose +dither -layers Optimize -resize 600x600\> out-static*.png  GIF:- | gifsicle --colors 128 --delay=5 --loop --optimize=3 --multifile - > $1.gif
      rm out-static*.png
    else
      ffmpeg -i $1 -s 600x400 -pix_fmt rgb24 -r 10 -f gif - | gifsicle --optimize=3 --delay=3 > $1.gif
    fi
  else
    echo "proper usage: gifify <input_movie.mov>. You DO need to include extension."
  fi
}

cleanSpec() {
  local rspecCommand="be rspec $(pbpaste | awk '{print $2}' | awk -F: '{print $1}' | sort -u | grep -v spec/shared/ | tr '\n' ' ')"
  echo "$rspecCommand"
  echo "$rspecCommand" | pbcopy
}