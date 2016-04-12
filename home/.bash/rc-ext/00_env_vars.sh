update_path() {
  for path_entry in "$@"; do
    if [[ -n "$path_entry" && -d "$path_entry" ]]; then
      export PATH="$path_entry:$PATH"
    fi
  done
}
update_path ~/bin ~/Code/bin ~/Code/Go/bin
update_path /usr/local/sbin
update_path /usr/local/bin

[[ -f ~/.api_keys.sh ]] && . ~/.api_keys.sh

if command -v brew >/dev/null; then
  update_path `brew --prefix`/share/npm/bin
fi

export EDITOR="subl -w -n"
export BUNDLER_EDITOR="subl"
export CLICOLOR=1
export GREP_OPTIONS='--color=auto'

export RUBY_GC_MALLOC_LIMIT=60000000
export RUBY_GC_HEAP_FREE_SLOTS=200000

export ARCHFLAGS='-arch x86_64 -arch i386'
export NODE_PATH="/usr/local/lib/node:"

export HISTSIZE=1000000000

export PYTHONSTARTUP="$HOME/.pythonrc"

# export ANSIBLE_TRANSPORT=ssh

export GOPATH="/Users/sutto/Code/Go"

export DOCKER_HOST=tcp://localhost:4243
