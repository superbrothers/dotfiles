" Options: {{{1

" initialize {{{2

set nocompatible
set shellslash

" encoding {{{2

if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  if iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213,euc-jp'
    let s:enc_jis = 'iso-2022-jp-3'
  endif

  let &fileencodings = 'ucs-bom'
  if has('guess_encode')
    let &fileencodings = &fileencodings . ',' . 'guess'
  endif
  if &encoding !=# 'utf-8'
    let &fileencodings = &fileencodings . ',' . 'ucs-2le'
    let &fileencodings = &fileencodings . ',' . 'ucs-2'
  endif
  let &fileencodings = &fileencodings . ',' . s:enc_jis

  if &encoding ==? 'utf-8'
    let &fileencodings = &fileencodings . ',' . 'cp932' . ',' . s:enc_euc
  elseif &encoding ==? 'cp932'
    let &fileencodings = &fileencodings . ',' . 'utf-8' . ',' . s:enc_euc
  elseif &encoding =~# '^euc-\%(jp\|jisx0213\)$'
    let &fileencodings = &fileencodings . ',' . 'utf-8' . ',' . 'cp932'
  endif

  unlet s:enc_euc
  unlet s:enc_jis
endif

function! s:recheck_fenc()
  if &l:fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
    let &l:fileencoding = &encoding
  endif
endfunction
augroup Encoding
  autocmd!
  autocmd BufReadPost * call s:recheck_fenc()
  autocmd BufWritePre,FileWritePre * if &l:fileencoding =~# '^utf-8' | setlocal nobomb | endif
  autocmd BufNewFile,BufRead * if &l:fileencoding =~# '^utf\|^ucs' | setlocal bomb | endif
augroup END

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
"set list
"行間を設定する
set linespace=0
"コマンドをステータスラインに表示
set showcmd
"コマンドラインに使われるスクリーン上の行数
set cmdheight=2
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
colorscheme wombat256
"statusline
"highlight LineNr ctermfg=darkgrey
"highlight Comment ctermfg=DarkCyan
" 補完候補の色づけ for vim7
hi Pmenu        ctermfg=Black ctermbg=Grey
hi PmenuSel     ctermbg=Blue
hi PmenuSbar    ctermbg=Cyan

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
"set shiftround

" indent {{{2

"新しい行を開始したときに、新しい行のインデントを現在行と同じ量にする
set autoindent
"バックスペースキーの動作を決定
set backspace=indent,eol,start
"新しい行を作ったときに高度な自動インデントを行う。
"set smartindent

" file {{{2

"外部のエディタで編集中のファイルが変更されたら、自動的に読み直す
set autoread
"変更中のファイルでも、保存しないで他のファイルを表示することが出来るようにする
set hidden

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
nnoremap <silent> bd :bd<CR>
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

" Filetype settings {{{1

" ruby {{{2
augroup RubyExtend
  autocmd!
  autocmd FileType ruby,eruby setlocal fileencoding=utf-8
  autocmd FileType ruby,eruby setlocal ts=2 sts=2 sw=2
  autocmd FileType ruby,eruby setlocal omnifunc=rubycomplete#Complete
  autocmd BufNewFile *.rb 0r $HOME/.vim/templates/skeleton.rb
augroup END

" javascript {{{2
augroup JavascriptExtend
  autocmd!
  autocmd FileType javascript setlocal fileencoding=utf-8
  autocmd FileType javascript setlocal ts=2 sts=2 sw=2
  autocmd FileType javascript nmap ,e :JSLintUpdate<CR>
augroup END

" php {{{2
augroup PhpExtend
  autocmd!
  autocmd FileType php setlocal fileencoding=utf-8
  autocmd FileType php setlocal ts=4 sts=4 sw=4
  autocmd Bufread,BufNewFile *.inc setlocal filetype=php
  autocmd BufNewFile *.php,*.inc 0r $HOME/.vim/templates/skeleton.php
augroup END

" html {{{2
augroup HtmlExtend
  autocmd!
  autocmd FileType html setlocal fileencoding=utf-8
  autocmd FileType html setlocal ts=4 sts=4 sw=4
  autocmd BufNewFile *.html 0r $HOME/.vim/templates/skeleton.html
augroup END

" Plugins: {{{1

" minibufexpl.vim {{{2
" http://www.vim.org/scripts/script.php?script_id=159
" =====================================================
let g:miniBufExplMapWindowNavVim=1
let g:miniBufExplSplitBelow=0
let g:miniBufExplMapWindowNavArrows=1
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

" autocomplpop.vim {{{2
" http://www.vim.org/scripts/script.php?script_id=1879
" =====================================================
autocmd FileType php  let g:AutoComplPop_CompleteOption = '.,w,b,u,t,i,k~/.vim/dict/php.dict'

" gist.vim {{{2
" http://github.com/mattn/gist-vim
" ====================================================
let g:gist_detect_filetype = 1

" YangRing.vim {{{2
" http://www.vim.org/scripts/script.php?script_id=1234
" =====================================================
let g:yankring_history_file = ".yankring_history_file"

nmap ,y :YRShow<CR>
