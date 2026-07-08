#!/bin/zsh
OUTPUT="$(pwd)/Apps_List_$(date +"%Y%m%d").json"

echo "==> Scanning App Store apps"
app_store=()
while IFS= read -r app; do
  mdls -name kMDItemAppStoreHasReceipt "$app" 2>/dev/null | grep -q "1" && \
    app_store+=("$(basename "$app" .app)")
done < <(find /Applications -name "*.app" -maxdepth 2)
echo "    ${#app_store[@]} found"

echo "==> Scanning brew formulae and casks"
brew_formulae=()
brew_casks=()
if command -v brew &>/dev/null; then
  while IFS= read -r f; do brew_formulae+=("$f"); done < <(brew leaves 2>/dev/null)
  while IFS= read -r c; do brew_casks+=("$c"); done < <(brew list --cask 2>/dev/null)
fi
echo "    ${#brew_formulae[@]} formulae, ${#brew_casks[@]} casks"

echo "==> Checking shell-managed tools"
shell_tools=()
[[ -d "$HOME/.oh-my-zsh" ]] && shell_tools+=("oh-my-zsh")
[[ -d "$HOME/.nvm" ]]        && shell_tools+=("nvm")
command -v node &>/dev/null  && shell_tools+=("node@$(node -v | tr -d v)")
command -v brew &>/dev/null  && shell_tools+=("homebrew@$(brew --version | head -1 | awk '{print $2}')")
for mgr in pyenv rbenv goenv tfenv rustup volta mise asdf; do
  command -v $mgr &>/dev/null && shell_tools+=("$mgr@$(${mgr} --version 2>&1 | head -1)")
done
echo "    ${#shell_tools[@]} found"

echo "==> Mapping casks to app names"
brew_cask_apps=()
if command -v brew &>/dev/null; then
  for cask in "${brew_casks[@]}"; do
    echo "    $cask"
    brew_cask_apps+=("$(brew info --cask "$cask" 2>/dev/null | grep -oE '/Applications/[^(]+\.app' | head -1 | xargs basename 2>/dev/null | sed 's/\.app//')")
  done
fi

echo "==> Identifying manually installed apps"
manual_apps=()
while IFS= read -r app; do
  name="$(basename "$app" .app)"
  receipt=$(mdls -name kMDItemAppStoreHasReceipt "$app" 2>/dev/null | grep -c "1")
  [[ $receipt -eq 0 ]] || continue
  skip=0
  for ca in "${brew_cask_apps[@]}"; do [[ "$ca" == "$name" ]] && skip=1 && break; done
  [[ $skip -eq 1 ]] && continue
  [[ "$name" == "Safari" ]] && continue
  manual_apps+=("$name")
done < <(find /Applications -name "*.app" -maxdepth 2)
echo "    ${#manual_apps[@]} found"

to_json_array() {
  local arr=("$@")
  local sorted=()
  while IFS= read -r line; do sorted+=("$line"); done < <(printf '%s\n' "${arr[@]}" | sort -f)
  local json="["
  for i in "${!sorted[@]}"; do
    local escaped="${sorted[$i]//\\/\\\\}"
    escaped="${escaped//\"/\\\"}"
    json+="\"$escaped\""
    [[ $i -lt $(( ${#sorted[@]} - 1 )) ]] && json+=","
  done
  json+="]"
  echo "$json"
}

[[ -f "$OUTPUT" ]] && echo "Warning: $OUTPUT already exists and will be overwritten."

echo "==> Writing JSON"
cat > "$OUTPUT" <<EOF
{
  "generated_at": "$(date +"%A, %B %d, %Y at %I:%M:%S %p %Z")",
  "shell": $(to_json_array "${shell_tools[@]}"),
  "brew": {
    "formulae": $(to_json_array "${brew_formulae[@]}"),
    "casks": $(to_json_array "${brew_casks[@]}")
  },
  "app_store": $(to_json_array "${app_store[@]}"),
  "manual_dmg_pkg": $(to_json_array "${manual_apps[@]}")
}
EOF

echo "==> Saved to $OUTPUT"
cat "$OUTPUT"