autocmd Bufread,BufNewFile *.cfl setlocal foldmethod=expr
autocmd Bufread,BufNewFile *.cfl setlocal foldexpr=CflFold(v:lnum)

function! CflFold(lnum)
  if getline(a:lnum) =~ '^h[1-6]\.'
    return '>1'
  else
    return '='
  endif
endfunction
