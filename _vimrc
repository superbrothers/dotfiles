" setup for vundle
" git clone git://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

" setup for golang
" go get github.com/nsf/gocode
" go get golang.org/x/tools/cmd/godoc
" go get golang.org/x/tools/cmd/goimports

" initialize {{{1

set nocompatible
set shellslash
filetype off

" Vundle {{{2

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Bundle files {{{3
" plugin {{{4
" github
Bundle 'gmarik/vundle'
Bundle 'mattn/gist-vim'
Bundle 'mattn/webapi-vim'
Bundle 'Shougo/neocomplete.vim'
Bundle 'Shougo/neosnippet'
Bundle 'Shougo/neosnippet-snippets'
" Bundle 'hallettj/jslint.vim'
Bundle 'scrooloose/syntastic'
Bundle 'othree/eregex.vim'
Bundle 'scrooloose/nerdcommenter'
Bundle 'vim-ruby/vim-ruby'
Bundle 'tpope/vim-rails'
Bundle 'pix/vim-align'
Bundle 'scrooloose/nerdtree'
Bundle 'superbrothers/vim-bclose'
" Bundle 'fholgado/minibufexpl.vim'
Bundle 'fholgado/minibufexpl.vim'
Bundle 'edsono/vim-viewoutput'
Bundle 'tpope/vim-fugitive'
Bundle 'vim-scripts/sudo.vim'
Bundle 'ujihisa/neco-rubymf'
Bundle 'mrtazz/simplenote.vim'
Bundle 'Shougo/unite.vim'
Bundle 'Shougo/neomru.vim'
Bundle 'Shougo/vimfiler'
Bundle 'mattn/jscomplete-vim'
Bundle 'myhere/vim-nodejs-complete'
Bundle 'airblade/vim-gitgutter'
Bundle 'sorah/presen.vim'
Bundle 'itchyny/lightline.vim'
Bundle 'Yggdroot/indentLine'
Bundle 'thinca/vim-quickrun'
Bundle 'tyru/open-browser.vim'
Bundle 'superbrothers/vim-quickrun-markdown-gfm'
Bundle 'fatih/vim-go'
Bundle 'google/vim-ft-go'
Bundle 'vim-jp/vim-go-extra'
" vim-scripts repos
Bundle 'YankRing.vim'
Bundle 'grep.vim'
Bundle 'renamer.vim'

" syntax {{{4
" github
Bundle 'tpope/vim-haml'
Bundle 'kchmck/vim-coffee-script'
Bundle 'vim-scripts/JavaScript-syntax'
Bundle 'vim-scripts/jade.vim'
Bundle 'superbrothers/vim-vimperator'
Bundle 'hail2u/vim-css3-syntax'
Bundle 'plasticboy/vim-markdown'
Bundle 'elzr/vim-json'
Bundle 'ekalinin/Dockerfile.vim'

" vim-scripts repos
Bundle 'confluencewiki.vim'

" colorscheme {{{4
" github
Bundle 'vim-scripts/Lucius'
Bundle 'mrkn/mrkn256.vim'
Bundle 'vim-scripts/wombat256.vim'
"Bundle 'altercation/vim-colors-solarized'
Bundle 'tomasr/molokai'
Bundle 'chriskempson/vim-tomorrow-theme'
Bundle 'w0ng/vim-hybrid'
Bundle 'jnurmine/Zenburn'

" Options: {{{1

" encoding {{{2

set encoding=utf-8
set fileencoding=utf-8

" 文字コードの自動認識
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif

set fileformat=unix
set fileformats=unix,dos,mac

if exists('&ambiwidth')
  if has('kaoriya')
    set ambiwidth=auto
  else
    set ambiwidth=double
  endif
endif

" display {{{2

"エラー音の代わりに画面フラッシュを使う(画面端で詰まる)
"set visualbell
"行番号を表示する
set number
"ルーラー（右下に表示される行・列の番号）を表示する
set ruler
"常にステータスラインを表示する
set laststatus=2
"行末に $ を置く
set list
"タブの可視化
set listchars=tab:>-,trail:_
"行間を設定する
set linespace=0
"コマンドをステータスラインに表示
set showcmd
"コマンドラインに使われるスクリーン上の行数
set cmdheight=1
"閉じ括弧が入力されたとき、対応する括弧を表示
set showmatch
"強調表示
syntax on
"検索結果をハイライトする
set hlsearch
"マーカーで折り畳み
set foldmethod=marker
"カーソルがある画面上の行を強調する
set cursorline
"256色
set t_Co=256
"使用するカラースキーム
colorscheme zenburn
"コピー/ペーストにクリップボードを利用する
set clipboard=unnamed

" backup {{{2

set backup
set backupdir=$HOME/.vim-bak/
set swapfile
set directory=$HOME/.vim-bak/
set viewdir=$HOME/.vim/view/

" tab {{{2

"ファイル内の <Tab> が対応する空白の数
set tabstop=4
"自動インデントの各段階に使われる空白の数
set shiftwidth=4
"<Tab>を押した時に挿入される空白の量(0:ts'で指定した量
set softtabstop=0
"タブをスペースに置き換える
set expandtab
"インデントを'shiftwidth' の値の倍数に丸める
set shiftround

" indent {{{2

"新しい行を開始したときに、新しい行のインデントを現在行と同じ量にする
set autoindent
"バックスペースキーの動作を決定
set backspace=indent,eol,start
"新しい行を作ったときに高度な自動インデントを行う。
set smartindent

" file {{{2

"外部のエディタで編集中のファイルが変更されたら、自動的に読み直す
set autoread
"変更中のファイルでも、保存しないで他のファイルを表示することが出来るようにする
set hidden
"カレントディレクトリを自動で変更する
if exists("+autochdir")
    set autochdir
endif

" search {{{2

"検索で、大文字小文字を区別しない
set ignorecase
"検索で小文字なら大文字を無視、大文字なら無視しない設定
set smartcase
"検索をファイルの末尾まで検索したら、ファイルの先頭へループする
set wrapscan
"インクリメンタルな検索を行う
set incsearch

" history {{{2

"コマンドを記録する数
set history=100

" complete {{{2

set infercase
"補完候補を表示する
set wildmenu
"補完モードの指定
set wildmode=list:longest,full
"omni補完できるようにする
setlocal omnifunc=syntaxcomplete#Complete
" プレビューウィンドウを展開しない
" http://vim.wikia.com/wiki/Omnicomplete_-_Remove_Python_Pydoc_Preview_Window
set completeopt-=preview

" help {{{2

" 日本語ヘルプを使う
set helplang=ja

" modeline
set modeline
set modelines=5

" filetype {{{2

filetype plugin indent on

" Keymap: {{{1

" 表示行単位で移動するようにする {{{2
nmap j gj
nmap k gk
vmap j gj
vmap k gk

" emacs-like-keys {{{2
cnoremap <C-B> <Left>
cnoremap <C-F> <Right>
cnoremap <C-A> <Home>
cnoremap <C-E> <End>
cnoremap <A-b> <S-Left>
cnoremap <A-f> <S-Right>

inoremap <C-A> <Home>
inoremap <C-B> <Left>
inoremap <C-D> <Del>
inoremap <C-E> <End>
inoremap <C-F> <Right>
inoremap <A-n> <Down>
inoremap <A-p> <Up>
inoremap <A-b> <S-Left>
inoremap <A-f> <S-Right>

" buffer {{{2
nnoremap <silent> bb :b#<CR>
nnoremap <silent> bp :bp<CR>
nnoremap <silent> bn :bn<CR>
nnoremap <silent> bd :Bclose<CR>
"nnoremap ls :ls<CR>:b

" date/time {{{2
inoremap <Leader>date <C-R>=strftime('%Y/%m/%d %H:%M:%S')<CR>
inoremap <Leader>time <C-R>=strftime('%H:%M')<CR>
inoremap <Leader>w3cd <C-R>=strftime('%Y-%m-%dT%H:%M:%S+09:00')<CR>

" close {{{2
nnoremap cl :close<CR>

" 検索ハイライト一時消去 {{{2
nnoremap  gh :nohlsearch<Return>

" 検索語が画面の真ん中に来るようにする {{{2
nmap n nzz
nmap N Nzz
nmap * *zz
nmap # #zz
nmap g* g*zz
nmap g# g#zz

" quick-vimrc {{{2
".vimrcを開く
nnoremap ,. :<C-u>edit $MYVIMRC<CR>
".vimrcを即座に反映する　
nnoremap ,s. :<C-u>source $MYVIMRC<CR>

" helpショートカット {{{2
nnoremap <C-h> :<C-u>help<Space>

" カーソル下のキーワードでhelpを検索 {{{2
nnoremap <C-h><C-h> :<C-u>help<Space><C-r><C-w><CR>

" ファイルを実行する {{{2
nmap ,e :execute '!' &ft ' %'<CR>

" 連結後のスペース削除 {{{2
"nmap J J<C-[>x

" fileformatを変更  {{{2
nmap ,d :set fileformat=dos<cr>
nmap ,m :set fileformat=mac<cr>
nmap ,u :set fileformat=unix<cr>
"pasteモードトグル
nnoremap <Space>tp :<C-u>set paste!<CR>

" folding {{{2
noremap ,j zj
noremap ,k zk
noremap ,n ]z
noremap ,p [z
noremap ,h zc
noremap ,l zo
noremap ,a za
noremap ,m zM
noremap ,i zMzv
noremap ,r zR
noremap ,f zf

" Function: {{{1

" function String2Hex {{{2
" The function String2Hex() converts each character in a string to a two
" character Hex string.
function! s:String2Hex(str)
    let out = ''
    let ix = 0
    while ix < strlen(a:str)
        let out = out . s:Nr2Hex(char2nr(a:str[ix]))
        let ix = ix + 1
    endwhile
    return out
endfunc

" omni補完をTabで実行 {{{2
function! InsertTabWrapper()
    if pumvisible()
        return "\<c-n>"
    endif
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k\|<\|/'
        return "\<tab>"
    elseif exists('&omnifunc') && &omnifunc == ''
        return "\<c-n>"
    else
        return "\<c-x>\<c-o>"
    endif
endfunction
inoremap <silent> <tab> <c-r>=InsertTabWrapper()<cr>

" Command: {{{1

" 文字コードを指定して開き直す {{{2
command! Cp932     edit ++enc=cp932<CR>
command! Utf8      edit ++enc=utf-8<CR>
command! Eucjp     edit ++enc=euc-jp<CR>
command! Iso2022jp edit ++enc=iso2022jp<CR>
command! Jis       Iso2022jp
command! Sjis      Cp932

" Ex: {{{1

" 前回終了したカーソル行に移動 {{{2
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

" bash なシンタックスハイライトを利用する
let g:is_bash = 1

" Filetype settings {{{1

autocmd Bufread,BufNewFile *.inc setlocal filetype=php
autocmd Bufread,BufNewFile *.cfl setlocal filetype=confluencewiki
autocmd Bufread,BufNewFile *.pentadactylrc setlocal filetype=vimperator

" Plugins: {{{1

" minibufexpl.vim {{{2
let g:miniBufExplMapWindowNavVim=1
let g:miniBufExplSplitBelow=0
let g:miniBufExplMapWindowNavArrows=0
let g:miniBufExplMapCTabSwitchBuffs=1
let g:miniBufExplModSelTarget=1
let g:miniBufExplSplitToEdge=1

nmap <Space>  :MBEbn<CR>
nnoremap ,1   :e #1<CR>
nnoremap ,2   :e #2<CR>
nnoremap ,3   :e #3<CR>
nnoremap ,4   :e #4<CR>
nnoremap ,5   :e #5<CR>
nnoremap ,6   :e #6<CR>
nnoremap ,7   :e #7<CR>
nnoremap ,8   :e #8<CR>
nnoremap ,9   :e #9<CR>

" gist.vim {{{2
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1
if has('mac')
    let g:gist_browser_command = 'open -a Firefox %URL%'
else
    let g:gist_browser_command = 'w3c %URL%'
endif

" YangRing.vim {{{2
let g:yankring_history_dir = $HOME.'/'
let g:yankring_history_file = '.yankring_history'
let g:yankring_paste_v_akey = ''
let g:yankring_paste_v_bkey = ''
let g:yankring_paste_v_key  = ''

nmap ,y :YRShow<CR>
" neocomplete {{{2
" Disable AutoComplPop. Comment out this line if AutoComplPop is not installed.
" let g:acp_enableAtStartup = 0
" Launches neocomplete automatically on vim startup.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Use camel case completion.
let g:neocomplete#enable_camel_case_completion = 1
" Use underscore completion.
let g:neocomplete#enable_underbar_completion = 1
" Sets minimum char length of syntax keyword.
let g:neocomplete#min_syntax_length = 3
" buffer file name pattern that locks neocomplete. e.g. ku.vim or fuzzyfinder 
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define file-type dependent dictionaries.
let g:neocomplete#dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
    \ }

" Define keyword, for minor languages
if !exists('g:neocomplete#keyword_patterns')
  let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" SuperTab like snippets behavior.
"imap <expr><TAB> neocomplete#sources#snippets_complete#expandable() ? "\<Plug>(neocomplete#snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplete#smart_close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=jscomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion, which require computational power and may stall the vim.
if !exists('g:neocomplete#omni_patterns')
  let g:neocomplete#omni_patterns = {}
endif
let g:neocomplete#omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
let g:neocomplete#omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplete#omni_patterns.c = '\%(\.\|->\)\h\w*'
let g:neocomplete#omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'
let g:neocomplete#omni_patterns.go = '\h\w*'

" neosnippet
" ==========
" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

" eregex.vim {{{2
" http://www.vim.org/scripts/script.php?script_id=3282
" =====================================================
nnoremap / :M/
nnoremap ,/ /

" NERD_commenter.vim {{{2
" http://www.vim.org/scripts/script.php?script_id=1218
" =====================================================
let g:NERDSpaceDelims = 1
let g:ERDCompactSexyComs = 1
nmap ,, <Plug>NERDCommenterToggle
vmap ,, <Plug>NERDCommenterToggle

" grep.vim {{{2
" http://www.vim.org/scripts/script.php?script_id=311
" =====================================================
let Grep_Default_Options = '-i'
let Grep_Skip_Dirs = 'CVS .svn .git'

" vim-coffee-script {{{2
" let coffee_compile_vert = 1

" simplenote.vim {{{2
" let g:SimplenoteUsername = 'email address'
" let g:SimplenotePassword = 'verysecret'
if filereadable($HOME . "/.simplenote.vim")
    source $HOME/.simplenote.vim
endif
let g:SimplenoteVertical=1
let g:SimplenoteSortOrder="pinned,modifydate"
let g:SimplenoteFiletype="markdown"

" syntastic {{{2
let g:syntastic_mode_map = { 'mode': 'passive',
                           \ 'active_filetypes': ['ruby'],
                           \ 'passive_filetypes': [] }

" unite.vim {{{2
""" unite.vim
" 入力モードで開始する
let g:unite_enable_start_insert=0
" バッファ一覧
nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
" ファイル一覧
nnoremap <silent> ,uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
" レジスタ一覧
nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR>
" 最近使用したファイル一覧
nnoremap <silent> ,um :<C-u>Unite file_mru<CR>
" 常用セット
nnoremap <silent> ,uu :<C-u>Unite buffer file_mru<CR>
" 全部乗せ
nnoremap <silent> ,ua :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>

" ウィンドウを分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
" ウィンドウを縦に分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
au FileType unite inoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
" ESCキーを2回押すと終了する
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> q
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>q

" vimfiler.vim {{{2
" vimデフォルトのエクスプローラをvimfilerで置き換える
let g:vimfiler_as_default_explorer = 1
nnoremap <silent> ,vf :<C-u>VimFiler -buffer-name=explorer -split -simple -winwidth=35 -toggle -no-quit<CR>
nnoremap <silent> ,vfb :<C-u>VimFiler -buffer-name=explorer -split -simple -winwidth=35 -toggle -no-quit<CR>

" Vundler {{{2
let g:vundle_default_git_proto = "git"

" lightline.vim {{{2
" https://github.com/itchyny/lightline.vim#my-settings
let g:lightline = {
      \ 'colorscheme': 'solarized_dark',
      \ 'mode_map': { 'c': 'NORMAL' },
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'gitgutter', 'filename' ] ]
      \ },
      \ 'component_function': {
      \   'modified': 'MyModified',
      \   'readonly': 'MyReadonly',
      \   'fugitive': 'MyFugitive',
      \   'gitgutter': 'MyGitGutter',
      \   'filename': 'MyFilename',
      \   'fileformat': 'MyFileformat',
      \   'filetype': 'MyFiletype',
      \   'fileencoding': 'MyFileencoding',
      \   'mode': 'MyMode',
      \ },
      \ 'separator': { 'left': '⮀', 'right': '⮂' },
      \ 'subseparator': { 'left': '⮁', 'right': '⮃' }
      \ }

function! MyModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &ro ? '⭤' : ''
endfunction

function! MyFilename()
  return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() : 
        \  &ft == 'unite' ? unite#get_status_string() : 
        \  &ft == 'vimshell' ? substitute(b:vimshell.current_dir,expand('~'),'~','') : 
        \ '' != expand('%t') ? expand('%t') : '[No Name]') .
        \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()
  return &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head') && strlen(fugitive#head()) ? '⭠ '.fugitive#head() : ''
endfunction

function! MyGitGutter()
  if ! exists('*GitGutterGetHunkSummary')
        \ || ! get(g:, 'gitgutter_enabled', 0)
        \ || winwidth('.') <= 90
    return ''
  endif
  let symbols = [
        \ g:gitgutter_sign_added . ' ',
        \ g:gitgutter_sign_modified . ' ',
        \ g:gitgutter_sign_removed . ' '
        \ ]
  let hunks = GitGutterGetHunkSummary()
  let ret = []
  for i in [0, 1, 2]
    if hunks[i] > 0
      call add(ret, symbols[i] . hunks[i])
    endif
  endfor
  return join(ret, ' ')
endfunction

function! MyFileformat()
  return winwidth('.') > 70 ? &fileformat : ''
endfunction

function! MyFiletype()
  return winwidth('.') > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
  return winwidth('.') > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode()
  return winwidth('.') > 60 ? lightline#mode() : ''
endfunction

" indentLine {{{2
let g:indentLine_color_term = 239

" quickrun {{{2
let g:quickrun_config = {
\ 'markdown': {
\   'type': 'markdown/gfm',
\   'outputter': 'browser'
\ }
\ }

" finalize {{{1
filetype plugin indent on

" .vimrc.local
if filereadable(glob('~/.vimrc.local'))
  source ~/.vimrc.local
endif
