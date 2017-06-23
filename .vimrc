if has('vim_starting')
  set rtp+=~/.vim/plugged/vim-plug
  if !isdirectory(expand('~/.vim/plugged/vim-plug'))
    echo 'Install vim-plug...'
    call system('mkdir -p ~/.vim/plugged/vim-plug')
    call system('git clone https://github.com/junegunn/vim-plug.git ~/.vim/plugged/vim-plug/autoload')
  end

  if !isdirectory(expand('~/.vim-bak'))
    echo 'Create ~/.vim-bak directory for backup...'
    call system('mkdir -p ~/.vim-bak')
  end
endif

call plug#begin('~/.vim/plugged')
  " {{{
  Plug 'junegunn/vim-plug', {'dir': '~/.vim/plugged/vim-plug/autoload'}
  Plug 'banyan/recognize_charcode.vim'
  Plug 'Shougo/neocomplete.vim'
  Plug 'airblade/vim-gitgutter'
  Plug 'tpope/vim-fugitive'
  Plug 'itchyny/lightline.vim'
  Plug 'superbrothers/vim-bclose'
  Plug 'fholgado/minibufexpl.vim'
  Plug 'othree/eregex.vim'
  Plug 'Shougo/neosnippet'
  Plug 'Shougo/neosnippet-snippets'
  Plug 'scrooloose/nerdcommenter'
  Plug 'Shougo/unite.vim'
  Plug 'Shougo/unite-outline'
  Plug 'ujihisa/unite-colorscheme'
  Plug 'Shougo/neomru.vim'
  Plug 'editorconfig/editorconfig-vim'
  Plug 'yegappan/grep'
  Plug 'Shougo/neoinclude.vim'
  Plug 'Shougo/context_filetype.vim'
  Plug 'pix/vim-align'
  Plug 'vim-scripts/ViewOutput'
  Plug 'Yggdroot/indentLine'
  Plug 'vim-scripts/YankRing.vim'
  Plug 'noahfrederick/vim-skeleton'
  Plug 'mattn/webapi-vim'
  Plug 'thinca/vim-quickrun'
  Plug 'Shougo/vimproc.vim', { 'do': 'make' }
  Plug 'osyo-manga/shabadou.vim'
  Plug 'cohama/vim-hier'
  Plug 'dannyob/quickfixstatus'
  Plug 'osyo-manga/vim-watchdogs'
  Plug 'zerowidth/vim-copy-as-rtf'
  Plug 'majutsushi/tagbar', { 'tag': '*' }
  Plug 'mattn/gist-vim', { 'on': ['Gist'] }
  Plug 'qpkorr/vim-renamer', { 'on': ['Renamer'] }
  Plug 'vim-scripts/sudo.vim', { 'on': ['SudoRead', 'SudoWrite'] }
  Plug 'mrtazz/simplenote.vim', { 'on': ['SimplenoteNew', 'SimplenoteList', 'SimplenoteOpen'] }
  Plug 'scrooloose/nerdtree'
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'fatih/vim-go', { 'for': ['go'] }
  Plug 'google/vim-ft-go', { 'for': ['go'] }
  Plug 'vim-ruby/vim-ruby', { 'for': ['ruby'] }
  Plug 'tpope/vim-rails', { 'for': ['ruby'] }
  Plug 'junegunn/vim-emoji', { 'for': ['markdown', 'gitcommit'] }
  Plug 'godlygeek/tabular', { 'for': ['markdown'] }
  Plug 'plasticboy/vim-markdown', { 'for': ['markdown'] }
  Plug 'heavenshell/vim-jsdoc', { 'for': ['javascript'] }
  Plug 'pangloss/vim-javascript', { 'for': ['javascript'] }
  Plug 'mxw/vim-jsx', { 'for': ['javascript'] }
  Plug 'moll/vim-node', { 'for': ['javascript'] }
  Plug 'myhere/vim-nodejs-complete', { 'for': ['javascript'] }
  Plug 'tpope/vim-haml', { 'for': ['haml'] }
  Plug 'vim-scripts/jade.vim', { 'for': ['jade'] }
  Plug 'ekalinin/Dockerfile.vim', { 'for': ['Dockerfile'] }
  Plug 'chakrit/upstart.vim', { 'for': ['upstart'] }
  Plug 'hail2u/vim-css3-syntax', { 'for': ['css'] }
  Plug 'elzr/vim-json', { 'for': ['json'] }
  Plug 'justmao945/vim-clang', { 'for': ['c', 'cpp'] }
  Plug 'cespare/vim-toml', { 'for': ['toml'] }
  Plug 'google/vim-jsonnet', { 'for': ['jsonnet', 'libsonnet'] }
  Plug 'miyakogi/seiya.vim'
  Plug 'tyru/open-browser.vim'
  Plug 'rafi/vim-unite-issue'
  " colorscheme
  Plug 'jnurmine/Zenburn'
  Plug 'tomasr/molokai'
  Plug 'vim-scripts/Lucius'
  Plug 'mrkn/mrkn256.vim'
  Plug 'vim-scripts/wombat256.vim'
  Plug 'tomasr/molokai'
  Plug 'chriskempson/vim-tomorrow-theme'
  Plug 'w0ng/vim-hybrid'
  Plug 'jnurmine/Zenburn'
  " }}}
call plug#end()

""" Encoding
set encoding=utf-8
set fileencoding=utf-8

""" Display
set number
set ruler
set laststatus=2
set list
set listchars=tab:>-,trail:_
set linespace=0
set showcmd
set cmdheight=1
set showmatch
syntax on
set hlsearch
set foldmethod=marker
set cursorline
set t_Co=256
set background=dark
colorscheme hybrid
set clipboard=unnamedplus,unnamed
set concealcursor=
set completeopt=menu,menuone

""" Backup
set backup
set backupdir=$HOME/.vim-bak/
set swapfile
set directory=$HOME/.vim-bak/
set viewdir=$HOME/.vim/view/

""" Tab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set shiftround

""" Indent
set autoindent
set backspace=indent,eol,start
set smartindent

""" File
set autoread
set hidden
set autochdir

""" Search
set ignorecase
set smartcase
set wrapscan
set incsearch

""" History
set history=100

""" Complete
set infercase
set wildmenu
set wildmode=list:longest,full

""" Modeline
set modeline
set modelines=5

""" FileType
filetype plugin indent on

""" Key Remap
" Move cursor by display lines when wrapping 
nmap j gj
nmap k gk
vmap j gj
vmap k gk

" emacs like keys
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

" Operate buffer
nnoremap <silent> bb :b#<CR>
nnoremap <silent> bp :bp<CR>
nnoremap <silent> bn :bn<CR>
nnoremap <silent> bd :Bclose<CR>

" Insert DateTime
inoremap <Leader>date <C-R>=strftime('%Y/%m/%d %H:%M:%S')<CR>
inoremap <Leader>time <C-R>=strftime('%H:%M')<CR>
inoremap <Leader>w3cd <C-R>=strftime('%Y-%m-%dT%H:%M:%S+09:00')<CR>

" Close window
nnoremap cl :close<CR>

" No Search Highlight
nnoremap  gh :nohlsearch<Return>

" Make search results appear in the middle of the screen
nmap n nzz
nmap N Nzz
nmap * *zz
nmap # #zz
nmap g* g*zz
nmap g# g#zz

" Quick VIMRC
nnoremap ,. :<C-u>edit $MYVIMRC<CR>
nnoremap ,s. :<C-u>source $MYVIMRC<CR>

" Help
nnoremap <C-h> :<C-u>help<Space>
nnoremap <C-h><C-h> :<C-u>help<Space><C-r><C-w><CR>

" Execute current buffer
nmap ,e :execute '!' &ft ' %'<CR>

" Change file format
nmap ,d :set fileformat=dos<cr>
nmap ,m :set fileformat=mac<cr>
nmap ,u :set fileformat=unix<cr>

" Toggle paste mode
nnoremap <Space>tp :<C-u>set paste!<CR>

" Folding
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

" Resize window size more quickly
nnoremap <silent> <Leader>+ :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> <Leader>- :exe "resize " . (winheight(0) * 2/3)<CR>

" Reopen file by specifying the char code
command! Cp932     edit ++enc=cp932<CR>
command! Utf8      edit ++enc=utf-8<CR>
command! Eucjp     edit ++enc=euc-jp<CR>
command! Iso2022jp edit ++enc=iso2022jp<CR>
command! Jis       Iso2022jp
command! Sjis      Cp932

""" Extra
" Restore the last cursor position of a file
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

" Specify default shelltype to 'bash'
let g:is_bash = 1

" Plugins
" Shougo/neocomplete.vim {{{
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#enable_camel_case_completion = 1
let g:neocomplete#enable_underbar_completion = 1
let g:neocomplete#enable_quick_match = 1
let g:neocomplete#sources#syntax#min_keyword_length = 3
" let g:neocomplete#max_list = 30
let g:neocomplete#force_overwrite_completefunc = 1
" Enable omni completion
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType javascript setlocal omnifunc=nodejscomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)\w*'
let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
let g:neocomplete#sources#omni#input_patterns.javascript = '[^. *\t]\.\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.markdown = '\(^\| \):'
let g:neocomplete#sources#omni#input_patterns.gitcommit = '\(^\| \):'
let g:neocomplete#sources#omni#input_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.go = '\h\w*'
" }}}

" itchyny/lightline.vim {{{
let g:lightline = {
  \ 'colorscheme': 'jellybeans',
  \ 'mode_map': { 'c': 'NORMAL' },
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'gitgutter', 'filename' ], [ 'go' ] ]
  \ },
  \ 'component': {
  \   'go': '%#goStatuslineColor#%{LightLineGo()}%*',
  \ },
  \ 'component_function': {
  \   'modified': 'LightLineModified',
  \   'readonly': 'LightLineReadonly',
  \   'fugitive': 'LightLineFugitive',
  \   'gitgutter': 'LightLineGitGutter',
  \   'filename': 'LightLineFilename',
  \   'fileformat': 'LightLineFileformat',
  \   'filetype': 'LightLineFiletype',
  \   'fileencoding': 'LightLineFileencoding',
  \   'mode': 'LightLineMode',
  \ }
\ }

function! LightLineModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightLineReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &ro ? '⭤' : ''
endfunction

function! LightLineFilename()
  return ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'unite' ? unite#get_status_string() :
        \  &ft == 'vimshell' ? vimshell#get_status_string() :
        \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
endfunction

function! LightLineFugitive()
  if &ft !~? 'vimfiler\|gundo' && exists("*fugitive#head")
    let _ = fugitive#head()
    return strlen(_) ? '⭠ '._ : ''
  endif
  return ''
endfunction

function! LightLineGitGutter()
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

function! LightLineFileformat()
  return winwidth('.') > 70 ? &fileformat : ''
endfunction

function! LightLineFiletype()
  return winwidth('.') > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! LightLineFileencoding()
  return winwidth('.') > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! LightLineMode()
  return winwidth('.') > 60 ? lightline#mode() : ''
endfunction

function! LightLineGo()
  if ! exists('*go#statusline#Show')
    return ''
  endif
  return winwidth('.') > 70 ? go#statusline#Show() : ''
endfunction
" }}}

" mrtazz/simplenote.vim {{{
" let g:SimplenoteUsername = 'email address'
" let g:SimplenotePassword = 'verysecret'
let g:SimplenoteVertical=1
let g:SimplenoteSortOrder="pinned,modifydate"
let g:SimplenoteFiletype="markdown"
" }}}

" minibufexpl.vim {{{
let g:miniBufExplMapWindowNavVim=1
let g:miniBufExplSplitBelow=0
let g:miniBufExplMapWindowNavArrows=0
let g:miniBufExplMapCTabSwitchBuffs=1
let g:miniBufExplModSelTarget=1
let g:miniBufExplSplitToEdge=1

nnoremap ,1   :e #1<CR>
nnoremap ,2   :e #2<CR>
nnoremap ,3   :e #3<CR>
nnoremap ,4   :e #4<CR>
nnoremap ,5   :e #5<CR>
nnoremap ,6   :e #6<CR>
nnoremap ,7   :e #7<CR>
nnoremap ,8   :e #8<CR>
nnoremap ,9   :e #9<CR>
" }}}

" scrooloose/nerdtree {{{
let NERDTreeShowHidden=1
nnoremap <silent><C-e> :NERDTreeToggle<CR>
"" start NERDTree
autocmd VimEnter * if argc() > 0 && &filetype != "gitcommit" | NERDTree | endif
" go to previous (last accessed) window
autocmd VimEnter * wincmd p
"" close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" }}}

" othree/eregex.vim {{{
nnoremap / :M/
nnoremap ,/ /
" }}}

" Shougo/neosnippet {{{
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)
let g:neosnippet#snippets_directory = $HOME.'/.vim/snippets'
" }}}

" scrooloose/nerdcommenter {{{
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
nmap ,, <Plug>NERDCommenterToggle
vmap ,, <Plug>NERDCommenterToggle
" }}}

" Shougo/unite.vim {{{
let g:unite_enable_start_insert=0
nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
nnoremap <silent> ,uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR>
nnoremap <silent> ,um :<C-u>Unite file_mru<CR>
nnoremap <silent> ,uu :<C-u>Unite buffer file_mru<CR>
nnoremap <silent> ,ua :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>
nnoremap <silent> ,uc :<C-u>Unite colorscheme<CR>
nnoremap <silent> ,uo :<C-u>Unite outline<CR>
nnoremap <silent> ,ui :<C-u>Unite issue:github<CR>
" }}}

" justmao945/vim-clang {{{
let g:clang_auto = 0
" default 'longest' can not work with neocomplete
let g:clang_c_completeopt   = 'menuone'
let g:clang_cpp_completeopt = 'menuone'

let g:clang_c_options = '-std=c11'
" }}}

" vim-scripts/YangRing.vim {{{
let g:yankring_history_dir = $HOME.'/'
let g:yankring_history_file = '.yankring_history'
let g:yankring_paste_v_akey = ''
let g:yankring_paste_v_bkey = ''
let g:yankring_paste_v_key  = ''

nmap ,y :YRShow<CR>
" }}}

" Yggdroot/indentLine {{{
let g:indentLine_color_term = 239
let g:indentLine_concealcursor = ''
" }}}

" plasticboy/vim-markdown {{{
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_toc_autofit = 1
" }}}

" majutsushi/tagbar {{{
noremap <silent> ,t :TagbarToggle<CR>
let g:tagbar_autofocus = 1
let g:tagbar_type_go = {
  \ 'ctagstype' : 'go',
  \ 'kinds'     : [
    \ 'p:package',
    \ 'i:imports:1',
    \ 'c:constants',
    \ 'v:variables',
    \ 't:types',
    \ 'n:interfaces',
    \ 'w:fields',
    \ 'e:embedded',
    \ 'm:methods',
    \ 'r:constructor',
    \ 'f:functions'
  \ ],
  \ 'sro' : '.',
  \ 'kind2scope' : {
    \ 't' : 'ctype',
    \ 'n' : 'ntype'
  \ },
  \ 'scope2kind' : {
    \ 'ctype' : 't',
    \ 'ntype' : 'n'
  \ },
  \ 'ctagsbin'  : 'gotags',
  \ 'ctagsargs' : '-sort -silent'
\ }
" }}}

" fatih/vim-go {{{
let g:go_fmt_command = "goimports"
let g:go_list_type = "quickfix"
let g:go_auto_type_info = 1
let g:go_fmt_autosave = 1
let g:go_fmt_fail_silently = 1
let g:go_list_type = "quickfix"
" }}}

" osyo-manga/vim-watchdogs {{{
let g:watchdogs_check_BufWritePost_enable=1
" }}}

" thinca/vim-quickrun {{{
let g:quickrun_config = {
\   "go/watchdogs_checker": {
    \  "type": "watchdogs_checker/go_vet"
  \ }
\ }
" }}}

" thinca/vim-quickrun {{{
let g:seiya_auto_enable=1

" .vimrc.local {{{
if filereadable(glob('~/.vimrc.local'))
  source ~/.vimrc.local
endif
" }}}
