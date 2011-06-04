autocmd FileType php setlocal fileencoding=utf-8
autocmd FileType php setlocal ts=4 sts=4 sw=4
autocmd BufNewFile *.php,*.inc 0r $HOME/.vim/templates/skeleton.php
" enable folding for classes and functions
let php_folding = 1
