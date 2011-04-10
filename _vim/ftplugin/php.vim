" =====================================================
" PDV - phpDocumentor for vim
" =====================================================
autocmd FileType php inoremap <C-d> <ESC>:call phpDocSingle()<CR>i
autocmd FileType php nnoremap <C-d> :call phpDocSingle()<CR>
autocmd FileType php vnoremap <C-d> <>:call phpDocRange<CR>
