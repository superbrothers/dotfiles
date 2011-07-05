" initialize {{{1

set nocompatible
set shellslash
filetype off

" Vundle {{{2
" git clone http://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Bundle files {{{3
" plugin {{{4
" github
Bundle 'gmarik/vundle'
Bundle 'mattn/gist-vim '
Bundle 'Shougo/neocomplcache'
Bundle 'hallettj/jslint.vim'
Bundle 'othree/eregex.vim'
Bundle 'scrooloose/nerdcommenter'
Bundle 'vim-ruby/vim-ruby'
Bundle 'tpope/vim-rails'
Bundle 'pix/vim-align'
Bundle 'scrooloose/nerdtree'
Bundle 'rwfitzge/vim-bclose'
Bundle 'fholgado/minibufexpl.vim'
Bundle 'edsono/vim-viewoutput'
" vim-scripts repos
Bundle 'YankRing.vim'
Bundle 'grep.vim'
Bundle 'renamer.vim'

" syntax {{{4
" github
Bundle 'tpope/vim-haml'
Bundle 'kchmck/vim-coffee-script'

" vim-scripts repos
Bundle 'confluencewiki.vim'

" colorscheme {{{4
" github
Bundle 'larssmit/Lucius'
Bundle 'mrkn/mrkn256.vim'
Bundle 'vim-scripts/wombat256.vim'



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
"colorscheme wombat256
colorscheme lucius

" iconvが使用可能の場合、カーソル上の文字コードをエンコードに応じた表示にするGetB(を使用)
if has('iconv')
    set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %F%=[%{GetB()}]\ %l,%c%V%8P
else
    set statusline=%<%f\ %m\ %r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=\ (%v,%l)/%L%8P
endif

function! GetB() " {{{
    let c = matchstr(getline('.'), '.', col('.') - 1)
    let c = iconv(c, &enc, &fenc)
    return s:String2Hex(c)
endfunction
" :help eval-examples
" The function Nr2Hex() returns the Hex string of a number.
function! s:Nr2Hex(nr)
    let n = a:nr
    let r = ''
    while n
        let r = '0123456789ABCDEF'[n % 16] . r
        let n = n / 16
    endwhile
    return r
endfunc
" }}}

" backup {{{2

set backup
set backupdir=$HOME/.backup/
set swapfile
set directory=$HOME/.backup/
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

" help {{{2

" 日本語ヘルプを使う
set helplang=ja

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
"nmap n nzz
"nmap N Nzz
"nmap * *zz
"nmap # #zz
"nmap g* g*zz
"nmap g# g#zz

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
" screen {{{2
if &term =~ "screen"
  autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | silent!  exe '!echo -n "^[kv:%^[\\    "' | endif
  autocmd VimLeave * silent!  exe '!echo -n "^[k[`basename $PWD`]^[\\"'
endif

" 前回終了したカーソル行に移動 {{{2
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

" クリップボード共有 {{{2
" reference
" http://subtech.g.hatena.ne.jp/cho45/20061010/1160459376
" http://vim.wikia.com/wiki/Mac_OS_X_clipboard_sharing
"
" need 'set enc=utf-8' and
" below shell environment variable for UTF-8 characters
" export __CF_USER_TEXT_ENCODING='0x1F5:0x08000100:14'
"
" Vim(Mac)
if has('mac') && !has('gui')
    nnoremap <silent> <Space>y :.w !pbcopy<CR><CR>
    vnoremap <silent> <Space>y :w !pbcopy<CR><CR>
    nnoremap <silent> <Space>p :r !pbpaste<CR>
    vnoremap <silent> <Space>p :r !pbpaste<CR>
" GVim(Mac & Win)
else
    noremap <Space>y "+y
    noremap <Space>p "+p
endif

" MacVim {{{2
if has("gui_running")
  set fuoptions=maxvert,maxhorz
  au GUIEnter * set fullscreen

  set transparency=10
  set guifont=M+1VM+IPAG\ circle:h14
endif

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
let g:yankring_history_file = ".yankring_history_file"

nmap ,y :YRShow<CR>

" neocomplcache {{{2
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 4
"let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
"let g:neocomplcache_dictionary_filetype_lists = {
"    \ 'default' : '',
"    \ 'vimshell' : $HOME.'/.vimshell_hist',
"    \ 'scheme' : $HOME.'/.gosh_completions'
"    \ }

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"
" <TAB>: completion.
"inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()

imap <C-k> <Plug>(neocomplcache_snippets_expand)
smap <C-k> <Plug>(neocomplcache_snippets_expand)

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

if !exists('g:neocomplcache_omni_patterns')
    let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.php  = '[^. \t]->\h\w*\|\$\h\w*\|\%(=\s*new\|extends\)\s\+\|\h\w*::'

" jslint.vim {{{2
function! ToggleJSLintHighlightErrorLine()
    if g:JSLintHighlightErrorLine == 1
        let g:JSLintHighlightErrorLine = 0
    else
        let g:JSLintHighlightErrorLine = 1
    endif
    JSLintUpdate
endfunc
autocmd FileType javascript nmap ,e :call ToggleJSLintHighlightErrorLine()<CR>

" eregex.vim {{{2
" http://www.vim.org/scripts/script.php?script_id=3282
" =====================================================
" / で行なう通常の検索と :M/ を入れ替える
nnoremap / :M/
nnoremap ,/ /

" NERD_commenter.vim {{{2
" http://www.vim.org/scripts/script.php?script_id=1218
" =====================================================
let g:NERDSpaceDelims = 1
let g:ERDCompactSexyComs = 1

" grep.vim {{{2
" http://www.vim.org/scripts/script.php?script_id=311
" =====================================================
let Grep_Default_Options = '-i'
let Grep_Skip_Dirs = 'CVS .svn .git'

" finalize {{{1
filetype plugin indent on
