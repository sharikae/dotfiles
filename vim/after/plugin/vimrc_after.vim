" This loads after the dotfiles plugins so that plugin mappings can
" be overwritten.

if filereadable(expand("~/.dotfiles/vim/after/.vimrc.after"))
  source ~/.dotfiles/vim/after/.vimrc.after
endif

if filereadable(expand("~/.vimrc.after"))
  source ~/.vimrc.after
endif
