" =====================================================
" PDV - phpDocumentor for vim
" =====================================================
autocmd FileType php inoremap <C-d> <ESC>:call phpDocSingle()<CR>i
autocmd FileType php inoremap <C-d> :call phpDocSingle()<CR>
autocmd FileType php inoremap <C-d> <>:call phpDocRange<CR>
