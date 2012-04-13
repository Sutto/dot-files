update_path() {
  for path_entry in "$@"; do
    if [[ -n "$path_entry" && -d "$path_entry" ]]; then
      export PATH="$path_entry:$PATH"
    fi
  done
}
update_path ~/bin ~/Code/bin
update_path /usr/local/sbin
update_path /usr/local/bin

. ~/.api_keys.sh

if command -v brew >/dev/null; then
  update_path `brew --prefix`/share/npm/bin
fi

export EDITOR="subl -w"
export CLICOLOR=1
export GREP_OPTIONS='--color=auto'
export RUBYOPT="-rrubygems"

# REE tweaks to make it faster for specs.
export RUBY_HEAP_MIN_SLOTS=1000000
export RUBY_HEAP_SLOTS_INCREMENT=1000000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
export RUBY_GC_MALLOC_LIMIT=1000000000
export RUBY_HEAP_FREE_MIN=500000


export ARCHFLAGS='-arch x86_64 -arch i386'

export NODE_PATH="/usr/local/lib/node:"
