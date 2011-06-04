autocmd FileType ruby,eruby setlocal fileencoding=utf-8
autocmd FileType ruby,eruby setlocal ts=2 sts=2 sw=2
autocmd FileType ruby,eruby setlocal omnifunc=rubycomplete#Complete
autocmd BufNewFile *.rb 0r $HOME/.vim/templates/skeleton.rb
