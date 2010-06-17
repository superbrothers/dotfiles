" =====================================================
" basic setting
" =====================================================
set nocompatible        "Use Vim defaults instead of 100% vi compatibility
set visualbell          "エラー音の代わりに画面フラッシュを使う
set autoread            "外部のエディタで編集中のファイルが変更されたら、自動的に読み直す
set history=100         "コロンコマンドを記録する数 
set hidden              "変更中のファイルでも、保存しないで他のファイルを表示することが出来るようにする
set encoding=utf-8      "デフォルト文字コード UTF-8
filetype on
filetype plugin on

setlocal omnifunc=syntaxcomplete#Complete "omni補完できるようにする

" display
" =====================================================
set number              "行番号を表示する
set ruler               "ルーラー（右下に表示される行・列の番号）を表示する
set cmdheight=2         "コマンドラインに使われるスクリーン上の行数
set laststatus=2        "常にステータスラインを表示する

" iconvが使用可能の場合、カーソル上の文字コードをエンコードに応じた表示にするGetB(を使用)
if has('iconv')
    set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %F%=[%{GetB()}]\ %l,%c%V%8P
else
    set statusline=%<%f\ %m\ %r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=\ (%v,%l)/%L%8P
endif

set linespace=0         "行間を設定する
set wildmenu            "補完候補を表示する
set showcmd             "コマンドをステータスラインに表示

" syntax color
" =====================================================
syntax on               "強調表示
"set t_Co=256            "256色
colorscheme wombat256

" statusline
"highlight LineNr ctermfg=darkgrey
"highlight Comment ctermfg=DarkCyan

" 補完候補の色づけ for vim7
hi Pmenu        ctermfg=Black ctermbg=Grey
hi PmenuSel     ctermbg=Blue
hi PmenuSbar    ctermbg=Cyan

" search
" =====================================================
set ignorecase          "検索で、大文字小文字を区別しない
set smartcase           "検索で小文字なら大文字を無視、大文字なら無視しない設定 
set wrapscan            "検索をファイルの末尾まで検索したら、ファイルの先頭へループする
set hlsearch            "検索結果をハイライトする 

" edit
" =====================================================
set autoindent                 " 新しい行を開始したときに、新しい行のインデントを現在行と同じ量にする
set smartindent
set showmatch                  " 閉じ括弧が入力されたとき、対応する括弧を表示
set backspace=indent,eol,start " バックスペースキーの動作を決定
"set cindent                    " Cプログラムファイルの自動インデントを始める

" tab
" =====================================================
set expandtab           "タブをスペースに置き換える
set tabstop=4           "ファイル内の <Tab> が対応する空白の数
set shiftwidth=4        "自動インデントの各段階に使われる空白の数
set softtabstop=0       "<Tab>を押した時に挿入される空白の量(0:ts'で指定した量
set shiftround          "インデントを'shiftwidth' の値の倍数に丸める

" keymap
" =====================================================
" 表示行単位で移動するようにする
nmap j gj
nmap k gk
vmap j gj
vmap k gk

" command mode 時 tcsh風のキーバインドに
cmap <C-A> <Home>
cmap <C-F> <Right>
cmap <C-B> <Left>
"cmap <C-D> <Delete>
cmap <Esc>b <S-Left>
cmap <Esc>f <S-Right>

" date/time
inoremap <Leader>date <C-R>=strftime('%Y/%m/%d %H:%M:%S')<CR>
inoremap <Leader>time <C-R>=strftime('%H:%M')<CR>
inoremap <Leader>w3cd <C-R>=strftime('%Y-%m-%dT%H:%M:%S+09:00')<CR>

" buffer
nnoremap <silent> bb :b#<CR>
nnoremap <silent> bp :bp<CR>
nnoremap <silent> bn :bn<CR>
nnoremap <silent> bd :bd<CR>
"nnoremap ls :ls<CR>:b

"close
nnoremap cl :close<CR>

" 検索ハイライト一時消去
nnoremap  gh :nohlsearch<Return>

" 検索語が画面の真ん中に来るようにする
nmap n nzz 
nmap N Nzz 
nmap * *zz 
nmap # #zz 
nmap g* g*zz 
nmap g# g#zz

" .vimrcを開く
nnoremap ,. :<C-u>edit $MYVIMRC<CR>

" .vimrcを即座に反映する　
nnoremap ,s. :<C-u>source $MYVIMRC<CR>

" helpショートカット
nnoremap <C-h> :<C-u>help<Space>

" カーソル下のキーワードでhelpを検索
nnoremap <C-h><C-h> :<C-u>help<Space><C-r><C-w><CR>

" ファイルを実行する
nmap ,e :execute '!' &ft ' %'<CR>

" 連結後のスペース削除
nmap J J<C-[>x

" autocmd
" =====================================================
" vim起動で、screenに編集中ファイル名を表示 ＆
" vim終了で、screenにディレクトリ名を表示
if &term =~ "screen"
  autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | silent!  exe '!echo -n "^[kv:%^[\\    "' | endif
  autocmd VimLeave * silent!  exe '!echo -n "^[k[`basename $PWD`]^[\\"'
endif

" 前回終了したカーソル行に移動
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

" Ex Command
" =====================================================
" 文字コードを指定して開き直す
command! Cp932     edit ++enc=cp932<CR>
command! Utf8      edit ++enc=utf-8<CR>
command! Eucjp     edit ++enc=euc-jp<CR>
command! Iso2022jp edit ++enc=iso2022jp<CR>
command! Jis       Iso2022jp
command! Sjis      Cp932

" ファイルタイプを変更
nmap ,d :set fileformat=dos<cr>
nmap ,m :set fileformat=mac<cr>
nmap ,u :set fileformat=unix<cr>

" backup
" =====================================================
set nobackup              "ファイルを上書きする前にバックアップファイルを作る
"set backupdir=~/vim_backup
set noswapfile            "スワップファイルを使用する設定
"set directory=~/vim_backup

" 文字コード自動認識
" =====================================================
" http://www.kawaz.jp/pukiwiki/?vim#cb691f26
" =====================================================
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') == "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932','euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','.s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~#
      '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings =&fileencodings.','s:enc_euc
    endif
  endif
  "定数を処分
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

" =====================================================
"カーソル上の文字コードをエンコードに応じた表示にする
" =====================================================
"statuslineで文字コードを表示するための下請け関数です。

function! GetB()
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

" plugin
" .vim/plugin/
" =====================================================
" minibufexpl.vim
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

" =====================================================
" autocomplpop.vim
" http://www.vim.org/scripts/script.php?script_id=1879
" =====================================================
autocmd FileType php  let g:AutoComplPop_CompleteOption = '.,w,b,u,t,i,k~/.vim/dict/php.dict'

" =====================================================
" YangRing.vim
" http://www.vim.org/scripts/script.php?script_id=1234
" =====================================================
nmap ,y :YRShow<CR>
