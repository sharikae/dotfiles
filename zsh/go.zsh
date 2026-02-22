export GOPATH=$HOME/go

# Add Go binary paths if they exist
_go_paths=(
  "/usr/local/go/bin"
  "/opt/homebrew/opt/go/bin"
  "/usr/lib/go/bin"
  "/snap/go/current/bin"
)

for _go_dir in "${_go_paths[@]}"; do
  [[ -d "$_go_dir" ]] && export PATH="$PATH:$_go_dir"
done
unset _go_paths _go_dir

[[ -d "$GOPATH/bin" ]] && export PATH="$PATH:$GOPATH/bin"
