# rbenv configuration
if command -v rbenv > /dev/null 2>&1; then
  eval "$(rbenv init -)"
elif [[ -d "$HOME/.rbenv" ]]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi
