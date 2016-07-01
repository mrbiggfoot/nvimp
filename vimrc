"------------------------------------------------------------------------------
" Init plugins
"------------------------------------------------------------------------------

call plug#begin('~/neovim/plugged')

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'mrbiggfoot/vim-cpp-enhanced-highlight'
Plug 'mrbiggfoot/my-colors-light'

call plug#end()

"------------------------------------------------------------------------------
" Misc configuration
"------------------------------------------------------------------------------

" Make Backspace work
set backspace=indent,eol,start

" Catch mouse events
set mouse=a

" Disable wrapping
set nowrap

" Vim UI
set wildmenu " turn on wild menu, try typing :h and press <Tab>
set showcmd	" display incomplete commands
set cmdheight=1 " 1 screen lines to use for the command-line
set ruler " show the cursor position all the time
set hid " allow to change buffer without saving
set shortmess=atI " shortens messages to avoid 'press a key' prompt
set lazyredraw " do not redraw while executing macros (much faster)
set display+=lastline " for easy browse last line with wrap text
set laststatus=2 " always have status-line

" Show line numbers
set number

" Search (/)
set hls " Enable search pattern highlight
set incsearch " Do incremental searching
set ignorecase " Set search/replace pattern to ignore case
set smartcase " Set smartcase mode on, If there is upper case character in the search patern, the 'ignorecase' option will be override.

" Common indent settings
set shiftwidth=4
set tabstop=4
set sts=4
set noexpandtab
set autoindent
set smartindent
"see help cinoptions-values for more details
set	cinoptions=>s,e0,n0,f0,{0,}0,^0,:0,=s,l0,b0,g0,hs,ps,ts,is,+s,c3,C0,0,(0,us,U0,w0,W0,m0,j0,)20,*30

" File type specific indent settings
autocmd FileType c,cpp,proto,python,cmake,javascript,java setlocal sw=2 ts=2 sts=2 expandtab autoindent

" Uncomment the following to have Vim jump to the last position when reopening a file
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Enable syntax highlighting. In iTerm2, select 'Light Background' palette.
syntax on
colorscheme my_colors_light
