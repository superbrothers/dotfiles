exe "set rtp+=".globpath($GOPATH, "src/github.com/nsf/gocode/vim")
let g:gofmt_command = 'goimports'
setlocal fileencoding=utf8
setlocal sw=4 noexpandtab ts=4
autocmd BufWritePre <buffer> Fmt
