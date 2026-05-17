" by: h4rithd.com
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible
let mapleader=" "
let maplocalleader=" "

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Basic settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on
set encoding=utf-8
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
set updatetime=300
set ttyfast
set hidden
set noerrorbells
set visualbell
set t_vb=
set backspace=indent,eol,start
set colorcolumn=120
highlight ColorColumn ctermbg=238
set signcolumn=yes
set completeopt=menuone,noinsert,noselect

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
" Theme
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
silent! packadd! onedark.vim
try
    colorscheme onedark
catch
    colorscheme default
endtry

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
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>
nnoremap <Leader>wq :wq<CR>
nnoremap <Leader>Q :q!<CR>
nnoremap <Leader>- :sp<CR>
nnoremap <Leader>\| :vsp<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree + vim-devicons
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <silent> <Leader>f :NERDTreeToggle<CR>
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
" lightline status bar
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set noshowmode
let g:lightline = {
      \ 'colorscheme': 'onedark',
      \ 'active': {
      \   'left': [
      \     [ 'mode', 'paste' ],
      \     [ 'readonly', 'filename', 'modified' ]
      \   ],
      \   'right': [
      \     [ 'lineinfo' ],
      \     [ 'percent' ],
      \     [ 'fileformat', 'fileencoding', 'filetype' ]
      \   ]
      \ },
      \ }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-polyglot
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-polyglot works mostly automatically.
" Keep this before startup for better performance if needed:
let g:polyglot_disabled = []

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-matchup
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:matchup_matchparen_enabled = 1
let g:matchup_matchparen_offscreen = {'method': 'popup'}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-startify
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:startify_change_to_dir = 1
let g:startify_session_autoload = 0
let g:startify_session_persistence = 1
let g:startify_lists = [
      \ { 'type': 'files',     'header': ['   Recent files'] },
      \ { 'type': 'dir',       'header': ['   Current directory'] },
      \ { 'type': 'sessions',  'header': ['   Sessions'] },
      \ { 'type': 'bookmarks', 'header': ['   Bookmarks'] },
      \ ]

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-visual-multi
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Default key: Ctrl+n selects next occurrence.
" Useful:
"   Ctrl+n     select next occurrence
"   Ctrl+x     skip occurrence
"   Ctrl+p     previous occurrence
let g:VM_maps = {}
let g:VM_maps['Find Under'] = '<C-n>'
let g:VM_maps['Find Subword Under'] = '<C-n>'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-fugitive - Git inside Vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <silent> <Leader>gs :Git<CR>
nnoremap <silent> <Leader>gb :Git blame<CR>
nnoremap <silent> <Leader>gd :Gdiffsplit<CR>
nnoremap <silent> <Leader>gc :Git commit<CR>
nnoremap <silent> <Leader>gl :Git log<CR>
nnoremap <silent> <Leader>gp :Git push<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-floaterm - floating terminal
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:floaterm_width = 0.85
let g:floaterm_height = 0.80
let g:floaterm_position = 'center'
let g:floaterm_borderchars = '─│─│┌┐┘└'
nnoremap <silent> <Leader>t :FloatermToggle<CR>
nnoremap <silent> <Leader>tn :FloatermNew<CR>
nnoremap <silent> <Leader>tk :FloatermKill<CR>
nnoremap <silent> <Leader>tp :FloatermPrev<CR>
nnoremap <silent> <Leader>tj :FloatermNext<CR>
tnoremap <silent> <Esc> <C-\><C-n>:FloatermToggle<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" indentLine - vertical indent bars
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:indentLine_enabled = 1
let g:indentLine_char = '│'
let g:indentLine_first_char = '│'
let g:indentLine_showFirstIndentLevel = 1
set conceallevel=1
let g:indentLine_fileTypeExclude = [
      \ 'help',
      \ 'nerdtree',
      \ 'startify',
      \ 'vimwiki',
      \ 'markdown',
      \ 'text'
      \ ]

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Autocomplete
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" IMPORTANT:
" coc.nvim is used as the main autocomplete engine.
" vim-mucomplete is installed, but not enabled here to avoid conflicts.
let g:mucomplete#enable_auto_at_startup = 0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" coc.nvim - VSCode-like autocomplete / LSP
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1] =~# '\s'
endfunction
inoremap <silent><expr> <C-Space> coc#refresh()
nnoremap <silent> [g <Plug>(coc-diagnostic-prev)
nnoremap <silent> ]g <Plug>(coc-diagnostic-next)
nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gy <Plug>(coc-type-definition)
nnoremap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gr <Plug>(coc-references)
nnoremap <silent> K :call ShowDocumentation()<CR>
function! ShowDocumentation()
    if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
    else
        execute 'h '.expand('<cword>')
    endif
endfunction
nnoremap <silent> <Leader>rn <Plug>(coc-rename)
nnoremap <silent> <Leader>a <Plug>(coc-codeaction-selected)
xnoremap <silent> <Leader>a <Plug>(coc-codeaction-selected)
xmap <Leader>fm <Plug>(coc-format-selected)
nmap <Leader>fm <Plug>(coc-format-selected)
augroup h4rithd_coc
    autocmd!
    autocmd FileType python,json,javascript,typescript,html,css,yaml nnoremap <buffer> <Leader>ff :call CocAction('format')<CR>
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" highlighted yank
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:highlightedyank_highlight_duration = -1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ack/ag search
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ackprg = 'ag --nogroup --nocolor --column'
