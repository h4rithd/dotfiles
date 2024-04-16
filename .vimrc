" by: h4rithd.com
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
inoremap ii <Esc>       " remap Esc key to dubble i (ii)
syntax on               " enable syntax processing
set number              " show line numbers
set relativenumber      " show relative numbering
set showcmd             " show command in bottom bar
set cursorline          " highlight current line
set incsearch     		" search as characters are entered
set hlsearch      		" highlight matches
set ignorecase    		" Ignore case in searches by default
set smartcase	      	" But make it case sensitive if an uppercase is entered
set tabstop=4           " number of visual spaces per TAB
set softtabstop=4       " number of spaces in tab when editing
set shiftwidth=4        " Insert 4 spaces on a tab
set expandtab           " tabs are spaces, mainly because of python
set wildmenu            " visual autocomplete for command menu
set showmatch           " highlight matching [{()}]
set laststatus=2        " Show the status line at the bottom
set mouse+=a            " A necessary evil, mouse support
set splitbelow          " Open new vertical split bottom
set splitright          " Open new horizontal splits right
set linebreak           " Have lines wrap instead of continue off-screen
set scrolloff=8         " Keep cursor in approximately the middle of the screen
set updatetime=100      " Some plugins require fast updatetime
set ttyfast             " Improve redrawing
set hidden              " Allows having hidden buffers (not displayed in any window)
set undofile            " Maintain undo history between sessions
set undodir=~/.vim/undodir

filetype indent on      " load filetype-specific indent files
filetype plugin on      " load filetype specific plugin files

" Move 1 more lines up or down
nnoremap K :m .-2<CR>==
nnoremap J :m .+1<CR>==
vnoremap K :m '<-2<CR>gv=gv
vnoremap J :m '>+1<CR>gv=gv

" [-] onedark Plugin
packadd! onedark.vim
colorscheme onedark
" [-] vim-mucomplete plugin
set completeopt+=menuone
set completeopt+=noselect
let g:mucomplete#enable_auto_at_startup = 1
let g:mucomplete#completion_delay = 1
" [-] highlightedyank plugin
let g:highlightedyank_highlight_duration = -1

set noerrorbells visualbell t_vb=	" Disable annoying error noises
set backspace=indent,eol,start		" Make backspace behave in a more intuitive way

set colorcolumn=120
highlight ColorColumn ctermbg=238

let mapleader=" "       " leader is space

"  - |     --  Split with leader
nnoremap <Leader>- :sp<CR>
nnoremap <Leader>\| :vsp<CR>

"  w wq q   --  Quick Save
nmap <Leader>w :w<CR>
nmap <Leader>q :q<CR>
nmap <Leader>wq :wq<CR>
nmap <Leader>Q :q!<CR>

" Automatically closing braces
inoremap { {}<Esc>ha
inoremap ( ()<Esc>ha
inoremap [ []<Esc>ha
inoremap " ""<Esc>ha
inoremap ' ''<Esc>ha
inoremap ` ``<Esc>ha
