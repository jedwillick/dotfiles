set nocompatible
nnoremap <SPACE> <Nop>
let mapleader=" "

runtime ftplugin/man.vim

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLso ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin()
Plug 'sheerun/vim-polyglot'

Plug 'mhinz/vim-startify'
let g:startify_bookmarks = [ '~/.vimrc', '~/.bashrc' ]

Plug 'rhysd/vim-clang-format'
let g:clang_format#style_options = {
      \ "UseTab": "Never",
      \ "IndentWidth": 4,
      \ "DerivePointerAlignment": "false",
      \ "PointerAlignment": "Left",
      \ "AlignConsecutiveMacros": "true"}
let g:clang_format#auto_format = 1
let g:clang_format#detect_style_file = 1
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>

Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'preservim/nerdtree'
nnoremap \ :NERDTreeToggle<CR>


Plug 'AndrewRadev/sideways.vim'
nnoremap <leader>h :SidewaysLeft<CR>
nnoremap <leader>l :SidewaysRight<CR>


Plug 'itchyny/lightline.vim'

Plug 'ghifarit53/tokyonight-vim'
let g:tokyonight_disable_italic_comment = 1
let g:tokyonight_style = 'storm'

" Plug 'Yggdroot/indentLine'
" let g:indentLine_char = '│'
" let g:indentLine_showFirstIndentLevel = 1
" let g:indentLine_first_char = g:indentLine_char


Plug 'tpope/vim-commentary'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'

Plug 'andymass/vim-matchup'
let g:loaded_matchit = 1

Plug '~/.fzf'
Plug 'junegunn/fzf.vim'
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fh :Helptags<CR>

Plug 'ap/vim-buftabline'
Plug 'morhetz/gruvbox'
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_invert_selection = 0
let g:gruvbox_invert_tabline = 1
call plug#end()

set termguicolors
set background=dark
colorscheme gruvbox
let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ }

" function! CustomHighlights()
"   highlight! MatchParen cterm=bold gui=bold guifg=#ff9e64
"   highlight! link MatchWord MatchParen
"   highlight! link MatchParenCur MatchParen
"   highlight! link MatchBackground ColorColumn
"   highlight! Search guifg=#c0caf5 guibg=#3d59a1
"   highlight! IncSearch guifg=#1d202f guibg=#ff9e64
"   highlight! link CurSearch IncSearch
"   highlight! TabLineSel guifg=#a9b1d6 guibg=#282d42
" endfunction
"
" autocmd ColorScheme * call CustomHighlights()
autocmd FileType c setlocal commentstring=//\ %s


nnoremap <C-s> :w<CR>
nnoremap <silent> <CR> :noh<CR><CR>
nnoremap <silent> L :bnext<CR>
nnoremap <silent> H :bprev<CR>

let c_syntax_for_h = 1

syntax on                       " Enable syntax highlighting
filetype indent on              " Allow loading of language specific indentation
filetype plugin on
set t_Co=256                    " Allow vim to display all colours
set showmatch                   " Highlight matching parentheses
set tabstop=4                   " Set the number of visual spaces per tab
set expandtab                   " Write tabs as spaces
set shiftwidth=4                " Set the number of columns to indent with reindent operations
set number                      " Show line numbers
set relativenumber
set wildmenu                    " Turn on the autocomplete menu
set mouse=a                     " Enable mouse support
set ruler                       " Display the ruler in the bottom right corner
set cursorline                  " Highlight the current line
set backspace=indent,eol,start  " Allow backspace to work across lines
set hlsearch
set laststatus=2
set noshowmode
set incsearch
set fillchars+=vert:│

if !isdirectory($HOME."/.vim")
    call mkdir($HOME."/.vim", "", 0770)
endif
if !isdirectory($HOME."/.vim/undo-dir")
    call mkdir($HOME."/.vim/undo-dir", "", 0700)
endif
set undodir=~/.vim/undo-dir
set undofile


if &term =~ '^xterm'
  " Cursor in terminal:
	" Link: https://vim.fandom.com/wiki/Configuring_the_cursor
	" 0 -> blinking block not working in wsl
	" 1 -> blinking block
	" 2 -> solid block
	" 3 -> blinking underscore
	" 4 -> solid underscore
	" Recent versions of xterm (282 or above) also support
	" 5 -> blinking vertical bar
	" 6 -> solid vertical bar
  let &t_EI = "\e[2 q" " Normal mode
  let &t_SI = "\e[6 q" " Insert mode
  let &t_SR = "\e[3 q" " Replace mode
  silent !echo -ne "\e[2 q"
  autocmd VimLeave * silent !echo -ne "\e[5 q"
endif
