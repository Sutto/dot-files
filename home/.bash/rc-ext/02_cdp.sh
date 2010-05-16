# Change into a project directory"

project_binary=~/bin/projects

function lsp {
  if [[ "$1" = "-r" ]]; then $project_binary regenerate; fi
  $project_binary list
}

function cdp {
  local project_path=$($project_binary path "$1")
  if [[ ! -z "$project_path" ]]; then
    cd "$project_path"
  fi
}
