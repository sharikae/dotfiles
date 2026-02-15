# Android SDK platform-tools
_android_paths=(
  "$HOME/Library/Android/sdk/platform-tools"
  "$HOME/Android/Sdk/platform-tools"
)

for _android_dir in "${_android_paths[@]}"; do
  if [[ -d "$_android_dir" ]]; then
    export PATH="$PATH:$_android_dir"
    break
  fi
done
unset _android_paths _android_dir
