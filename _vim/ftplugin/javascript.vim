setlocal fileencoding=utf-8
setlocal ts=4 sts=4 sw=4
nmap ,e :SyntasticToggleMode<CR>

" npm install -g jslint
"nmap <F4> :w<CR>:make<CR>:cw<CR>
"setlocal makeprg=jslint\ %
"setlocal errorformat=%-P%f,
"                    \%-G/*jslint\ %.%#*/,
"                    \%*[\ ]%n\ %l\\,%c:\ %m,
"                    \%-G\ \ \ \ %.%#,
"                    \%-GNo\ errors\ found.,
"                    \%-Q

" Plugins

" jslint.vim
"function! ToggleJSLintHighlightErrorLine()
"    if g:JSLintHighlightErrorLine == 1
"        let g:JSLintHighlightErrorLine = 0
"    else
"        let g:JSLintHighlightErrorLine = 1
"    endif
"    JSLintUpdate
"endfunc
"nmap ,e :call ToggleJSLintHighlightErrorLine()<CR>
