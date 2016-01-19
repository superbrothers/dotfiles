exe "set rtp+=".globpath($GOPATH, "src/github.com/nsf/gocode/vim")
let g:gofmt_command = 'goimports'
autocmd BufWritePre <buffer> Fmt
