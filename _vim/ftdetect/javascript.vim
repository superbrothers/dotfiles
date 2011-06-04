autocmd FileType javascript setlocal fileencoding=utf-8
autocmd FileType javascript setlocal ts=2 sts=2 sw=2

" Plugins

" jslint.vim
function! ToggleJSLintHighlightErrorLine()
    if g:JSLintHighlightErrorLine == 1
        let g:JSLintHighlightErrorLine = 0
    else
        let g:JSLintHighlightErrorLine = 1
    endif
    JSLintUpdate
endfunc
nmap ,e :call ToggleJSLintHighlightErrorLine()<CR>
