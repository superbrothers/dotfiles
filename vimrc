if has('vim_starting')
  set rtp+=~/.vim/plugged/vim-plug
  if !isdirectory(expand('~/.vim/plugged/vim-plug'))
    echo 'Install vim-plug...'
    call system('mkdir -p ~/.vim/plugged/vim-plug')
    call system('git clone git://github.com/junegunn/vim-plug.git ~/.vim/plugged/vim-plug/autoload')
  end
endif

call plug#begin('~/.vim/plugged')
Plug 'junegunn/vim-plug', {'dir': '~/.vim/plugged/vim-plug/autoload'}
Plug 'superbrothers/vim-bclose'
Plug 'fholgado/minibufexpl.vim'
Plug 'Yggdroot/indentLine'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'fatih/molokai'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'scrooloose/nerdcommenter'
Plug 'mattn/gist-vim', { 'on': ['Gist'] }
Plug 'ekalinin/Dockerfile.vim', { 'for': ['Dockerfile'] }
Plug 'zerowidth/vim-copy-as-rtf'
Plug 'majutsushi/tagbar', { 'tag': '*' }
Plug 'elzr/vim-json', { 'for' : 'json' }
Plug 'tyru/open-browser.vim'
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 't9md/vim-choosewin'
Plug 'godlygeek/tabular', { 'for' : 'markdown' }
Plug 'plasticboy/vim-markdown', { 'for' : 'markdown' }
Plug 'noahfrederick/vim-skeleton'
Plug 'vim-scripts/YankRing.vim'
Plug 'othree/eregex.vim'
" vim-lsp
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'mattn/vim-goimports'
Plug 'mattn/vim-lsp-settings'
Plug 'mattn/vim-lsp-icons'
call plug#end()

set nocompatible
filetype off
filetype plugin indent on
set ttyfast
set lazyredraw
" http://stackoverflow.com/questions/20186975/vim-mac-how-to-copy-to-clipboard-without-pbcopy
set clipboard^=unnamed
set clipboard^=unnamedplus
" increase max memory to show syntax highlighting for large files
set maxmempattern=20000

""" ENCODING
set encoding=utf-8
set fileencoding=utf-8

""" DISPLAY
set number
set ruler
set laststatus=2
set list
set listchars=tab:>-,trail:_
set linespace=0
set showcmd
set cmdheight=1
set hlsearch
set foldmethod=marker
set nocursorcolumn
set nocursorline
set completeopt=menuone,noinsert
set conceallevel=0

""" COLOR
syntax on
set t_Co=256
set background=dark
let g:molokai_original = 1
let g:rehash256 = 1
colorscheme molokai

""" TAB
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set shiftround

""" INDENT
set autoindent
set backspace=indent,eol,start
set smartindent

""" FILE
set autoread
set autowrite
set hidden
set autochdir
set nobackup
set noswapfile

""" SEARCH
set ignorecase
set smartcase
set wrapscan
set incsearch

""" HISTORY
set history=1000

""" COMPLETE
set infercase
set wildmenu
set wildmode=list:longest,full

""" MODELINE
set modeline
set modelines=5

""" KEY REMAP
let mapleader = ","

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

" operate buffer
nnoremap <silent> bb :b#<CR>
nnoremap <silent> bp :bp<CR>
nnoremap <silent> bn :bn<CR>
nnoremap <silent> bd :Bclose<CR>

" insert datetime
inoremap <Leader>date <C-R>=strftime('%Y/%m/%d %H:%M:%S')<CR>
inoremap <Leader>time <C-R>=strftime('%H:%M')<CR>

" close window
nnoremap cl :close<CR>

" quick vimrc
nnoremap <Leader>. :<C-u>edit $MYVIMRC<CR>
nnoremap <Leader>s. :<C-u>source $MYVIMRC<CR>

" execute current buffer
nmap <Leader>e :execute '!' &ft ' %'<CR>

" toggle paste mode
nnoremap <Leader>tp :<C-u>set paste!<CR>

" no search highlight
nnoremap  gh :nohlsearch<CR>

inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <expr> <TAB> pumvisible() ? "\<Down>" : "\<TAB>"
inoremap <expr> <S-TAB> pumvisible() ? "\<Up>" : "\<S-TAB>"

""" PLUGINS

" indentLine ======================================
let g:indentLine_conceallevel=0

" minibufexpl =====================================
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

" vim-airline ======================================
let g:airline_theme='molokai'

" fugitive =========================================
vnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gb :Gblame<CR>

" fzf ===============================================
let g:fzf_command_prefix = 'Fzf'
let g:fzf_layout = { 'down': '~20%' }

" search 
nmap <Leader>p :FzfHistory<CR>
imap <Leader>p <esc>:<C-u>FzfHistory<cr>

" search across files in the current directory
nmap <Leader>[ :FzfFiles<cr>
imap <Leader>[ <esc>:<C-u>FzfFiles<cr>
let g:rg_command = '
  \ rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --color "always"
  \ -g "*.{js,json,php,md,styl,jade,html,config,py,cpp,c,go,hs,rb,conf}"
  \ -g "!{.git,node_modules,vendor}/*" '

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

command! -bang -nargs=* F call fzf#vim#grep(g:rg_command .shellescape(<q-args>), 1, <bang>0)

" NERDTree =========================================
let NERDTreeShowHidden=1
nnoremap <silent><C-e> :NERDTreeToggle<CR>
" start NERDTree
autocmd VimEnter * if argc() > 0 && &filetype != "gitcommit" | NERDTree | endif
" go to previous (last accessed) window
autocmd VimEnter * wincmd p
" close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" asyncomplete ====================================
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 0
" Force refresh completion
imap <C-Space> <Plug>(asyncomplete_force_refresh)
" To auto close preview window when completion is done.
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" vim-lsp =========================================
if empty(globpath(&rtp, 'autoload/lsp.vim'))
  finish
endif

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> <f2> <plug>(lsp-rename)
  nmap <silent> <Leader>d <plug>(lsp-type-definition)
  nmap <silent> <Leader>r <plug>(lsp-references)
  nmap <silent> <Leader>i <plug>(lsp-implementation)
endfunction

augroup lsp_install
  au!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

command! LspDebug let lsp_log_verbose=1 | let lsp_log_file = expand('~/lsp.log')

let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_text_edit_enabled = 1

" tagbar ===============================================
noremap <Leader>t :TagbarToggle<CR>
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

" vim-choosewin ==============================================
nmap - <Plug>(choosewin)
let g:choosewin_overlay_enable = 1

" vim-markdown ===============================================
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_toc_autofit = 1

" scrooloose/nerdcommenter ===================================
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
nmap ,, <Plug>NERDCommenterToggle
vmap ,, <Plug>NERDCommenterToggle

" vim-scripts/YangRing.vim  ==================================
let g:yankring_history_dir = $HOME.'/'
let g:yankring_history_file = '.yankring_history'
let g:yankring_paste_v_akey = ''
let g:yankring_paste_v_bkey = ''
let g:yankring_paste_v_key  = ''
nmap ,y :YRShow<CR>

" othree/eregex.vim ==========================================
nnoremap / :M/
nnoremap ,/ /

""" OTHERS

" Restore the last cursor position of a file
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

if filereadable(glob('~/.vimrc.local'))
  source ~/.vimrc.local
endif