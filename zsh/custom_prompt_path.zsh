#Load themes from dotfiles and from user's custom prompts (themes) in ~/.zsh.prompts
autoload promptinit
fpath=($HOME/.dotfiles/zsh/prezto-themes $HOME/.zsh.prompts $fpath)
promptinit
