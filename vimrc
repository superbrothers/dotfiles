if has('vim_starting')
  set rtp+=~/.vim/plugged/vim-plug
  if !isdirectory(expand('~/.vim/plugged/vim-plug'))
    echo 'Install vim-plug...'
    call system('mkdir -p ~/.vim/plugged/vim-plug')
    call system('git clone https://github.com/junegunn/vim-plug.git ~/.vim/plugged/vim-plug/autoload')
  end
endif

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
Plug 't9md/vim-choosewin'
Plug 'godlygeek/tabular', { 'for' : 'markdown' }
Plug 'plasticboy/vim-markdown', { 'for' : 'markdown' }
Plug 'noahfrederick/vim-skeleton'
Plug 'othree/eregex.vim'
Plug 'ap/vim-buftabline'
Plug 'fatih/vim-go', { 'for': 'go', 'do': ':GoInstallBinaries' }
Plug 'hashivim/vim-terraform', { 'for': 'tf' }
Plug 'cespare/vim-toml', { 'for': 'toml' }
Plug 'google/vim-jsonnet'
Plug 'qpkorr/vim-renamer'
Plug 'jjo/vim-cue', { 'for': 'cue' }
" vim-lsp
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'mattn/vim-goimports'
Plug 'mattn/vim-lsp-icons'

if has('mac')
  Plug 'zerowidth/vim-copy-as-rtf'
endif
call plug#end()

" Clear autocmds of this file so that re-sourcing does not duplicate them
augroup vimrc
  autocmd!
augroup END

set lazyredraw
" http://stackoverflow.com/questions/20186975/vim-mac-how-to-copy-to-clipboard-without-pbcopy
set clipboard^=unnamed
set clipboard^=unnamedplus
" increase max memory to show syntax highlighting for large files
set maxmempattern=20000

""" ENCODING
set encoding=utf-8

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
" Keep swap files to recover unsaved edits after a crash
set swapfile
" Keep undo history across restarts
set undofile
if !has('nvim')
  " Neovim already uses $XDG_STATE_HOME/nvim/{swap,undo}//; keep Vim's out of the working tree too
  for [s:opt, s:name] in [['directory', 'swap'], ['undodir', 'undo']]
    let s:dir = expand('~/.local/state/vim/' . s:name)
    if !isdirectory(s:dir)
      call mkdir(s:dir, 'p', 0700)
    endif
    execute 'let &' . s:opt . ' = s:dir . "//"'
  endfor
  unlet s:opt s:name s:dir
endif

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
nnoremap j gj
nnoremap k gk
xnoremap j gj
xnoremap k gk

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

" insert details tag
inoremap <Leader>details <details><CR><summary><code></code></summary><CR><CR></details><Up><Up><C-O>0<C-O>f><C-O>l

" close window
nnoremap cl :close<CR>

" quick vimrc
nnoremap <Leader>. :<C-u>edit $MYVIMRC<CR>
nnoremap <Leader>s. :<C-u>source $MYVIMRC<CR>

" execute current buffer
nmap <Leader>e :execute '!' &ft ' %'<CR>

" no search highlight
nnoremap  gh :nohlsearch<CR>

" don't yank with replaced word
xnoremap p "_dP

""" PLUGINS

" indentLine ======================================
let g:indentLine_conceallevel=0

" vim-airline ======================================
let g:airline_theme='molokai'

" fzf ===============================================
let g:fzf_command_prefix = 'Fzf'
let g:fzf_layout = { 'down': '~20%' }

nmap <Leader>p :FzfHistory<CR>
imap <Leader>p <esc>:<C-u>FzfHistory<cr>

nmap <Leader>] :FzfGFiles<CR>
imap <Leader>] <esc>:<C-u>FzfGFiles<CR>

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
let g:NERDTreeShowHidden=1
let g:NERDTreeChDirMode=2
nnoremap <silent><C-e> :NERDTreeToggle<CR>
" start NERDTree
autocmd vimrc VimEnter * if argc() > 0 && &filetype != "gitcommit" | NERDTree | endif
" go to previous (last accessed) window
autocmd vimrc VimEnter * wincmd p
" close vim if the only window left open is a NERDTree
autocmd vimrc BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" asyncomplete ====================================
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 0
" Force refresh completion
imap <C-Space> <Plug>(asyncomplete_force_refresh)
" To auto close preview window when completion is done.
autocmd vimrc CompleteDone * if pumvisible() == 0 | pclose | endif

" vim-lsp =========================================
if !empty(globpath(&rtp, 'autoload/lsp.vim'))
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

    if index(['go', 'rust'], &filetype) >= 0
      " Use a separate augroup so that re-sourcing vimrc keeps it
      augroup lsp_format
        autocmd! * <buffer>
        autocmd BufWritePre <buffer> LspDocumentFormatSync
      augroup END
    endif
  endfunction

  augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
  augroup END

  command! LspDebug let lsp_log_verbose=1 | let lsp_log_file = expand('~/lsp.log')
endif

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

" yank history ===============================================
" Pick a past yank with fzf and paste it.
" The uppercase name lets Neovim persist the history via ShaDa ('!' in 'shada').
let g:YANK_HISTORY = get(g:, 'YANK_HISTORY', [])

function! s:yank_history_add() abort
  if v:event.operator !=# 'y'
    return
  endif
  let l:entry = [join(v:event.regcontents, "\n"), v:event.regtype]
  if l:entry[0] =~# '^\s*$'
    return
  endif
  call filter(g:YANK_HISTORY, 'v:val !=# l:entry')
  call insert(g:YANK_HISTORY, l:entry)
  let g:YANK_HISTORY = g:YANK_HISTORY[:49]
endfunction

function! s:yank_history_paste(line) abort
  let l:entry = g:YANK_HISTORY[str2nr(matchstr(a:line, '^\d\+'))]
  " Paste through a scratch register so that the clipboard is not overwritten
  let l:saved = getreginfo('z')
  call setreg('z', l:entry[0], l:entry[1])
  normal! "zp
  call setreg('z', l:saved)
endfunction

function! s:yank_history_pick() abort
  call fzf#run(fzf#wrap({
        \ 'source': map(copy(g:YANK_HISTORY), 'v:key . "\t" . substitute(v:val[0], "\n", " ⏎ ", "g")'),
        \ 'sink': function('s:yank_history_paste'),
        \ 'options': ['--no-sort', '--delimiter', "\t", '--with-nth', '2..', '--prompt', 'Yank> '],
        \ }))
endfunction

if exists('##TextYankPost')
  autocmd vimrc TextYankPost * call s:yank_history_add()
endif
command! YankHistory call s:yank_history_pick()
nnoremap <silent> <Leader>y :<C-u>YankHistory<CR>

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

""" OTHERS

" Restore the last cursor position of a file
autocmd vimrc BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

if filereadable(glob('~/.vimrc.local'))
  source ~/.vimrc.local
endif
