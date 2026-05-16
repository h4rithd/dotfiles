" by: h4rithd.com

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible
let mapleader=" "
let maplocalleader=" "

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Basic settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on
set number
set relativenumber
set showcmd
set cursorline
set incsearch
set hlsearch
set ignorecase
set smartcase
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set wildmenu
set showmatch
set laststatus=2
set mouse+=a
set splitbelow
set splitright
set linebreak
set scrolloff=8
set updatetime=100
set ttyfast
set hidden
set noerrorbells
set visualbell
set t_vb=
set backspace=indent,eol,start
set colorcolumn=120
highlight ColorColumn ctermbg=238

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Undo history
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set undofile
if !isdirectory(expand("~/.vim/undodir"))
    call mkdir(expand("~/.vim/undodir"), "p")
endif
set undodir=~/.vim/undodir

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Filetype support
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype plugin indent on

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Insert mode mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remap Esc to ii
inoremap ii <Esc>
" Automatically closing braces and quotes
inoremap { {}<Esc>ha
inoremap ( ()<Esc>ha
inoremap [ []<Esc>ha
inoremap " ""<Esc>ha
inoremap ' ''<Esc>ha
inoremap ` ``<Esc>ha

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Move lines up/down
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap K :m .-2<CR>==
nnoremap J :m .+1<CR>==
vnoremap K :m '<-2<CR>gv=gv
vnoremap J :m '>+1<CR>gv=gv

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Leader mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Save / quit
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>
nnoremap <Leader>wq :wq<CR>
nnoremap <Leader>Q :q!<CR>
" Splits
nnoremap <Leader>- :sp<CR>
nnoremap <Leader>\| :vsp<CR>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree file sidebar + icons
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set encoding=utf-8
silent! packadd! nerdtree
silent! packadd! vim-devicons
" <Space>f opens/closes the sidebar
nnoremap <silent> <Leader>f :NERDTreeToggle<CR>
" <Space>F finds the current file in the sidebar
nnoremap <silent> <Leader>F :NERDTreeFind<CR>
let NERDTreeShowHidden=1
let NERDTreeWinSize=32
let NERDTreeMinimalUI=1
let NERDTreeDirArrows=1
let NERDTreeQuitOnOpen=0
let g:webdevicons_enable = 1
let g:webdevicons_enable_nerdtree = 1
let g:webdevicons_conceal_nerdtree_brackets = 1
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1
augroup h4rithd_nerdtree
    autocmd!
    autocmd BufEnter * if winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree() | quit | endif
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" onedark theme
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
silent! packadd! onedark.vim
try
    colorscheme onedark
catch
    colorscheme default
endtry

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-mucomplete
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set completeopt+=menuone
set completeopt+=noselect
let g:mucomplete#enable_auto_at_startup = 1
let g:mucomplete#completion_delay = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" highlighted yank
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:highlightedyank_highlight_duration = -1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ack/ag search
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ackprg = 'ag --nogroup --nocolor --column'
