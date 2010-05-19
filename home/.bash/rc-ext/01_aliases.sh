# All aliases for this shell.

alias bi="bundle install --disable-shared-gems .bundle-cache"
alias be="bundle exec"
alias gi="git init"
alias gc="git clone"
alias gr="git remote"

which hub && eval $(hub alias -s bash)


# Changes into the directory for a given gem.
function cdgem {
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

