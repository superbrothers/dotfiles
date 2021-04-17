if has('vim_starting')
  set rtp+=~/.vim/plugged/vim-plug
  if !isdirectory(expand('~/.vim/plugged/vim-plug'))
    echo 'Install vim-plug...'
    call system('mkdir -p ~/.vim/plugged/vim-plug')
    call system('git clone git://github.com/junegunn/vim-plug.git ~/.vim/plugged/vim-plug/autoload')
  end
endif

" detect os type
let uname = substitute(system('uname'), '\n', '', '')

call plug#begin('~/.vim/plugged')
Plug 'junegunn/vim-plug', {'dir': '~/.vim/plugged/vim-plug/autoload'}
Plug 'superbrothers/vim-bclose'
Plug 'Yggdroot/indentLine'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'fatih/molokai'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'scrooloose/nerdcommenter'
Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim', { 'on': ['Gist'] }
Plug 'ekalinin/Dockerfile.vim', { 'for': ['Dockerfile'] }
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
Plug 'ap/vim-buftabline'
Plug 'fatih/vim-go', { 'for': 'go', 'do': ':GoInstallBinaries' }
" vim-lsp
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'mattn/vim-goimports'
Plug 'mattn/vim-lsp-icons'

if uname == 'Linux'
  Plug 'wincent/vim-clipper'
endif
if uname == 'Darwin'
  Plug 'zerowidth/vim-copy-as-rtf'
endif
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
highlight Normal ctermbg=NONE guibg=NONE
highlight NonText ctermbg=NONE guibg=NONE
highlight SpecialKey ctermbg=NONE guibg=NONE
highlight EndOfBuffer ctermbg=NONE guibg=NONE

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

" don't yank with replaced word
xnoremap p "_dP

""" PLUGINS

" indentLine ======================================
let g:indentLine_conceallevel=0

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
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gs <plug>(lsp-document-symbol-search)
  nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
  nmap <buffer> gr <plug>(lsp-references)
  nmap <buffer> gi <plug>(lsp-implementation)
  nmap <buffer> gt <plug>(lsp-type-definition)
  nmap <buffer> <leader>rn <plug>(lsp-rename)
  nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
  nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
  nmap <buffer> K <plug>(lsp-hover)

  autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
endfunction

augroup lsp_install
  au!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

command! LspDebug let lsp_log_verbose=1 | let lsp_log_file = expand('~/lsp.log')

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

" vim-go =================================-=
let g:go_code_completion_enabled = 0
let g:go_gopls_enabled = 1
let g:go_fmt_autosave = 0
let g:go_mod_fmt_autosave = 0
let g:go_asmfmt_autosave = 0
let g:go_metalinter_autosave = 0
let g:go_auto_type_info = 0

" othree/eregex.vim ==========================================
nnoremap / :M/
nnoremap ,/ /

" vim-clipper ================================================
let g:ClipperAddress = '~/.clipper.sock'
let g:ClipperPort = 0
" disable vim-clipper if ~/.clipper.sock does not exist
if empty(glob('~/.clipper.sock'))
  let g:ClipperLoaded = 1
endif

""" OTHERS

" Restore the last cursor position of a file
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

if filereadable(glob('~/.vimrc.local'))
  source ~/.vimrc.local
endif
