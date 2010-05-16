function __load_all_ext_under {
  local load_under_path="$1"
  for config in $(find "$load_under_path" -ipath '**/*.sh'); do
    [[ -r "$config" ]] && source "$config"
  done
}
