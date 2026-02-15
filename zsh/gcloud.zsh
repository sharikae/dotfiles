# Google Cloud SDK configuration
# Supports Homebrew (macOS), apt/snap (Linux), and manual installations

_gcloud_paths=(
  "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk"
  "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk"
  "/usr/share/google-cloud-sdk"
  "/snap/google-cloud-cli/current"
  "$HOME/google-cloud-sdk"
)

for _gcloud_dir in "${_gcloud_paths[@]}"; do
  if [[ -f "$_gcloud_dir/path.zsh.inc" ]]; then
    source "$_gcloud_dir/path.zsh.inc"
    [[ -f "$_gcloud_dir/completion.zsh.inc" ]] && source "$_gcloud_dir/completion.zsh.inc"
    break
  fi
done
unset _gcloud_paths _gcloud_dir
