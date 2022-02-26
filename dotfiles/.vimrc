" set nocompatible

"--------------------------------------------------------------------
"   HIGHLIGHTING AND SYNTAX
"--------------------------------------------------------------------
set background=dark             " Use a dark background by default
syntax on                       " Enable syntax highlighting
set t_Co=256                    " Allow vim to display all colours
set showmatch                   " Highlight matching parentheses
colorscheme desert

"--------------------------------------------------------------------
"   INDENTATION
"--------------------------------------------------------------------
set tabstop=8                   " Set the number of visual spaces per tab
"set softtabstop=4               " Set the number of spaces a tab counts as
"set expandtab                   " Write tabs as spaces
set autoindent                  " Turn on auto-indentation
set shiftwidth=4                " Set the number of columns to indent with reindent operations
filetype indent on              " Allow loading of language specific indentation

"--------------------------------------------------------------------
"   COLOUR COLUMN
"--------------------------------------------------------------------
set colorcolumn=80              " Create a column at the 80 character line
highlight ColorColumn ctermbg=8 guibg=lightgrey

"--------------------------------------------------------------------
"   MISCELLANEOUS
"--------------------------------------------------------------------
set number                      " Show line numbers
set wildmenu                    " Turn on the autocomplete menu
"set mouse=a                     " Enable mouse support
set ruler                       " Display the ruler in the bottom right corner
set cursorline                  " Highlight the current line
set backspace=indent,eol,start  " Allow backspace to work across lines
filetype plugin on


call plug#begin()
Plug 'preservim/nerdcommenter'
Plug 'rhysd/vim-clang-format'
Plug 'joshdick/onedark.vim'
Plug 'sheerun/vim-polyglot'
Plug 'itchyny/lightline.vim'
call plug#end()

set laststatus=2
set noshowmode
let g:lightline = {
      \ 'colorscheme': 'deus',
      \ }

let g:NERDSpaceDelims = 1
let g:NERDAltDelims_c = 1
let g:NERDDefaultAlign = 'left'

let g:clang_format#style_options = {
            \ "PointerAlignment" : "Left"}
let g:clang_format#auto_format = 1
" let g:clang_format#detect_style_file = 1
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>


