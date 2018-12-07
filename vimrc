set nocompatible
set autoindent
set fileformats=unix,dos
set shiftwidth=4
set showmatch     " highlight matching [{()}]
set tabstop=8     " number of visual spaces per TAB
set expandtab     " tabs are spaces
set softtabstop=4 " number of spaces in tab when editing
set showcmd       " show command in bottom bar
set ttyfast
set undolevels=10
set visualbell
set ignorecase

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

set smartcase
set incsearch
set wrap
set hlsearch

filetype off
syntax enable " enable syntax processing
set wildmenu            " visual autocomplete for command menu

" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <Tab> <c-r>=InsertTabWrapper()<cr>
inoremap <S-Tab> <c-n>

" colorscheme desert
" colorscheme monokai
set background=dark
colorscheme solarized
" Airline plugin customization
set laststatus=2 "So that I dont have to split for airline to show up
let g:airline_theme='kolor'
let g:airline#extensions#wordcount#enabled = 1

call pathogen#infect()
call pathogen#helptags()

filetype plugin indent on    " required


set tags=./tags;/panos,tags;/panos
" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor
  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'
endif
set makeprg=mk

let g:ag_working_path_mode='r'
let g:NERDTreeDirArrows=0 " else NERTree cannot change directories
let g:NERDTreeMinimalUI = 1
  " CtrlP path veriable options
  " c - the directory of the current file.
  " a - like "c", but only applies when the current working directory outside of
  "     CtrlP isn't a direct ancestor of the directory of the current file.
  " r - the nearest ancestor that contains one of these directories or files:
  "     .git .hg .svn .bzr _darcs
  " w - begin finding a root from the current working directory outside of CtrlP
  "     instead of from the directory of the current file (default). Only applies
  "     when "r" is also present.
  " 0 or <empty> - disable this feature.
let g:ctrlp_working_path_mode = 'ra'

function! MarkWindowSwap()
    let g:markedWinNum = winnr()
endfunction

function! DoWindowSwap()
    "Mark destination
    let curNum = winnr()
    let curBuf = bufnr( "%" )
    exe g:markedWinNum . "wincmd w"
    "Switch to source and shuffle dest->source
    let markedBuf = bufnr( "%" )
    "Hide and open so that we aren't prompted and keep history
    exe 'hide buf' curBuf
    "Switch to dest and shuffle source->dest
    exe curNum . "wincmd w"
    "Hide and open so that we aren't prompted and keep history
    exe 'hide buf' markedBuf
endfunction

function! TrimWhitespace()
    let l:save = winsaveview()
    %s/\s\+$//e
    call winrestview(l:save)
endfunction

"This unsets the "last search pattern" register by hitting return
nnoremap <CR> :noh<CR><CR>

" Use Ctrl-J to switch splits rather than C-W-J
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nmap <silent> <leader>mw :call MarkWindowSwap()<CR>
nmap <silent> <leader>pw :call DoWindowSwap()<CR>

nmap <silent> <leader>a :VCSAnnotate<CR>
nmap <silent> <leader>d :VCSVimDiff<CR>
nmap <silent> <leader>t :NERDTreeToggle<CR>
nmap <silent> <leader>s :call TrimWhitespace()<CR>
nmap <silent> <leader>w :DiffChangesDiffToggle<CR>
nmap <silent> <leader>i :set diffopt+=iwhite<CR>
nmap <silent> <leader>o <C-W>F <C-J> <leader>d
nmap <silent> <leader>c :cs find call <C-r><C-w><CR>

"Look for function under cursor in tags file and open it in a new window
map <C-\> :split<CR>:exec("tag ".expand("<cword>"))<CR>

" Quick Grep
noremap K :grep!<space><C-r><C-w><CR>:copen<CR><CR><C-W>b

" Automatically open, but do not go to (if there are errors) the quickfix /
" location list window, or close it when is has become empty.
"
" Note: Must allow nesting of autocmds to enable any customizations for quickfix
" buffers.
" Note: Normally, :cwindow jumps to the quickfix window if the command opens it
" (but not if it's already open). However, as part of the autocmd, this doesn't
" seem to happen.
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow
" Resize splits when the window is resized
au VimResized * exe "normal! \<c-w>="
au BufNewFile * set noeol
