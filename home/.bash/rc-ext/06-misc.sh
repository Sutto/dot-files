showAppFile() {
  openssl smime -verify -inform der -noverify -nosigs 2>/dev/null | jq
  echo
}

fetchAppAssociation() {
  curl -L "http://$1/apple-app-site-association" 2>/dev/null | showAppFile "-"
}

showPlist() {
local name="$1"
  local file="$(unzip -l "$name" | egrep 'Payload/[^\/]+.app/Info.plist' | sed 's/.*Payload/Payload/')"
  echo ">> $file"
  unzip -p "$name" "$file" | plutil -convert json -o - - | jq '. | .CFBundleURLTypes'
}

showURIs() {
local name="$1"
  local file="$(unzip -l "$name" | egrep 'Payload/[^\/]+.app/Info.plist' | sed 's/.*Payload/Payload/')"
  echo ">> $file"
  unzip -p "$name" "$file" | plutil -convert json -o - - | jq -r '. | .CFBundleURLTypes | .[] | .CFBundleURLSchemes | .[]' | sort -u
}