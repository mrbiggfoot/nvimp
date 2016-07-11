"------------------------------------------------------------------------------
" Init plugins
"------------------------------------------------------------------------------

call plug#begin('~/neovim/plugged')

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'vim-scripts/a.vim'
Plug 'moll/vim-bbye'
Plug 'tpope/vim-obsession'

Plug 'mrbiggfoot/vim-cpp-enhanced-highlight'
Plug 'mrbiggfoot/my-colors-light'

function! DoRemote(arg)
	UpdateRemotePlugins
endfunction
Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote') }

call plug#end()

"------------------------------------------------------------------------------
" Plugins configuration
"------------------------------------------------------------------------------

" Use deoplete
let g:deoplete#enable_at_startup = 1
" deoplete tab-complete
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

"------------------------------------------------------------------------------
" Projects configuration
"------------------------------------------------------------------------------

if has('vim_starting')
	let s:vimp_path = fnamemodify(resolve(expand('<sfile>:p')), ':h')
endif

function! s:configure_project()
	" prj_meta_root must be an absolute path, or 'lid' won't work
	let prj_meta_root = $VIMP_PROJECTS_META_ROOT
	let cur_prj_root = getcwd()
	let cur_prj_branch = system('git rev-parse --abbrev-ref HEAD 2>/dev/null')
	let cur_prj_branch = substitute(cur_prj_branch, '\n', '', '')
	let cur_prj_meta_root = prj_meta_root . cur_prj_root . '/' . cur_prj_branch

	if isdirectory(cur_prj_meta_root)
		let cur_prj_ctags = cur_prj_meta_root . "/tags"

		" The following line is needed for project files opener key mapping
		let g:cur_prj_files = cur_prj_meta_root . "/files"

		" The following line specifies the IDs db path
		let g:unite_ids_db_path = cur_prj_meta_root . "/ID"

		exec "set tags=" . cur_prj_ctags . ";"
	endif
endfunction

call s:configure_project()

function! s:update_project()
	exec '!' . s:vimp_path . '/project_generate.sh'
	call s:configure_project()
endfunction

"------------------------------------------------------------------------------
" Keyboard shortcuts
"------------------------------------------------------------------------------

" Enter insert mode - F13 on Mac
nnoremap <Esc>[1;2P :startinsert<CR>

" Word navigation
nnoremap <Esc>b b
nnoremap <Esc>f e

inoremap <Esc>b <C-Left>
inoremap <Esc>f <C-Right>
" Ctrl-left|right on Mac
inoremap <Esc>[1;5D <C-Left>
inoremap <Esc>[1;5C <C-Right>

" Opt-up|down scrolling
nnoremap <Esc>[1;9B <C-e>
nnoremap <Esc>[1;9A <C-y>
inoremap <Esc>[1;9B <C-x><C-e>
inoremap <Esc>[1;9A <C-x><C-y>
nnoremap . <C-e>
nnoremap ; <C-y>

" Ctrl-up|down scrolling
nnoremap <C-Down> <C-e>
nnoremap <C-Up> <C-y>
inoremap <C-Down> <C-x><C-e>
inoremap <C-Up> <C-x><C-y>

" Window navigation: Shift-arrows
inoremap <S-Left> <C-o><C-w><Left>
inoremap <S-Right> <C-o><C-w><Right>
inoremap <S-Up> <C-o><C-w><Up>
inoremap <S-Down> <C-o><C-w><Down>

nnoremap <S-Left> <C-w><Left>
nnoremap <S-Right> <C-w><Right>
nnoremap <S-Up> <C-w><Up>
nnoremap <S-Down> <C-w><Down>

" Buffer navigation
" Ctrl-left|right
nnoremap <C-Left> :bprev<CR>
nnoremap <C-Right> :bnext<CR>

" Enhance '<' '>' - do not need to reselect the block after shift it.
vnoremap < <gv
vnoremap > >gv

" Close buffer
nnoremap <leader>q :Bdelete<CR>

" Alt-c|v - copy/paste from X clipboard.
vnoremap ç "+y
nnoremap ç V"+y:echo "1 line yanked"<CR>
nnoremap √ "+P
inoremap √ <C-o>"+P

" Alt-/ - switch to correspondent header/source file
nnoremap ÷ :A<CR>
inoremap ÷ <C-o>:A<CR>
" Alt-Shift-/ - swich to file under cursor
nnoremap ¿ :IH<CR>
inoremap ¿ <C-O>:IH<CR>

function! SwapWindowWith(pos)
	let l:cur_wnd = winnr()
	let l:cur_buf = bufnr('%')
	let l:cur_view = winsaveview()
	exec "100wincmd h"
	if a:pos > 1
		exec (a:pos - 1) . "wincmd l"
	endif
	let l:swap_buf = bufnr('%')
	let l:swap_view = winsaveview()
	exec "b " . l:cur_buf
	call winrestview(l:cur_view)
	exec l:cur_wnd . "wincmd w"
	exec "b " . l:swap_buf
	call winrestview(l:swap_view)
endfunction

nnoremap 11 :call SwapWindowWith(1)<CR>
nnoremap 22 :call SwapWindowWith(2)<CR>
nnoremap 33 :call SwapWindowWith(3)<CR>
nnoremap 44 :call SwapWindowWith(4)<CR>

function! ToggleColorColumn()
  if &colorcolumn == 0
    set colorcolumn=80
  else
    set colorcolumn=0
  endif
endfunction
nnoremap <F7> :call ToggleColorColumn()<CR>
inoremap <F7> <C-o>:call ToggleColorColumn()<CR>

nnoremap <leader>8 :vertical resize 90<CR>

function! DupRight()
  let l:cur_wnd = winnr()
  let l:cur_view = winsaveview()
  let l:cur_buf = bufnr('%')
  exec "wincmd l"
  if winnr() == l:cur_wnd
    exec "wincmd v"
    exec "wincmd l"
  endif
  exec "b " . l:cur_buf
  call winrestview(l:cur_view)
endfunction
nnoremap <Bar> :call DupRight()<CR>

" F2 - browse buffer tags
nnoremap <F2> :BTags<CR>
inoremap <F2> <Esc>:BTags<CR>

" F3 - browse buffers
function! BufWindow()
	let l:num_bufs = len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) + 2
	if exists("g:fzf_layout")
		let l:saved_layout = g:fzf_layout
	endif
	exec 'let g:fzf_layout = {"window":"belowright ' . l:num_bufs . 'new"}'
	exec "Buffers"
	if exists("l:saved_layout")
		let g:fzf_layout = l:saved_layout
	else
		unlet g:fzf_layout
	endif
endfunction
nnoremap <F3> :call BufWindow()<CR>
inoremap <F3> <Esc>:call BufWindow()<CR>

" F8 - clear highlight of the last search until the next search
nnoremap <Esc>[19~ :noh<CR>
inoremap <Esc>[19~ <C-o>:noh<CR>

" Cmd-F9|F10 - backward/forward jump stack navigation
nnoremap <Esc>[20;3~ <C-o>
nnoremap <Esc>[21;3~ <C-i>
inoremap <Esc>[20;3~ <C-o><C-o>
inoremap <Esc>[21;3~ <C-o><C-i>

" Ctrl-P - open list of files
function! FilesCmd(file_source)
	return ':call fzf#run({"source":"' . a:file_source . '", "sink":"e",
		\"up":"~40%", "options":"--reverse --bind=tab:down"})<CR>'
endfunction
if exists("g:cur_prj_files")
	let s:ctrl_p_cmd = FilesCmd('cat ' . g:cur_prj_files)
else
	let s:ctrl_p_cmd = FilesCmd('find .')
endif
exec 'nnoremap <C-p> ' . s:ctrl_p_cmd
exec 'inoremap <C-p> <Esc>' . s:ctrl_p_cmd

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
set hls			" Enable search pattern highlight
set incsearch	" Do incremental searching
set ignorecase	" Set search/replace pattern to ignore case
set smartcase	" Set smartcase mode on, If there is upper case character in
				" the search patern, the 'ignorecase' option will be override.

" Common indent settings
set shiftwidth=4
set tabstop=4
set sts=4
set noexpandtab
set autoindent
set smartindent
" See help cinoptions-values for more details
set	cinoptions=>s,e0,n0,f0,{0,}0,^0,:0,=s,l0,b0,g0,hs,ps,ts,is,+s,c3,C0,0,
	\(0,us,U0,w0,W0,m0,j0,)20,*30

" File type specific indent settings
autocmd FileType c,cpp,proto,python,cmake,javascript,java
	\ setlocal sw=2 ts=2 sts=2 expandtab autoindent

" Jump to the last position when reopening a file
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") |
	\ exe "normal! g'\"" | endif

" Enable syntax highlighting. In iTerm2, select 'Light Background' palette.
syntax on
colorscheme my_colors_light

" Restore the previous session, if required
if @% == '' && filereadable("./Session.vim")
	silent source ./Session.vim
endif
