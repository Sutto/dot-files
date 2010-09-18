update_path() {
  for path_entry in "$@"; do
    if [[ -n "$path_entry" && -d "$path_entry" ]]; then
      export PATH="$path_entry:$PATH"
    fi
  done
}
update_path ~/bin ~/Code/bin

if command -v brew >/dev/null; then
  update_path `brew --prefix`/share/npm/bin
fi

export EDITOR="/usr/local/bin/mate_w"
export CLICOLOR=1
export GREP_OPTIONS='--color=auto'
export RUBYOPT=-rubygems
