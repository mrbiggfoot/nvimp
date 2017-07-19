"------------------------------------------------------------------------------
" Init plugins
"------------------------------------------------------------------------------

call plug#begin('~/neovim/plugged')

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'vim-scripts/a.vim'
Plug 'moll/vim-bbye'
Plug 'tpope/vim-obsession'
Plug 'Yggdroot/indentLine'
Plug 'neomake/neomake'

Plug 'mrbiggfoot/vim-cpp-enhanced-highlight'
Plug 'mrbiggfoot/my-colors-light'
Plug 'mrbiggfoot/unite-tselect2'
Plug 'mrbiggfoot/unite-id'
Plug 'mrbiggfoot/deoplete-filesrc'

Plug 'Shougo/unite.vim'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

call plug#end()

"------------------------------------------------------------------------------
" Plugins configuration
"------------------------------------------------------------------------------

" Use deoplete
let g:deoplete#enable_at_startup = 1
" deoplete tab-complete
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
" The cache size should be > tags file size for 'tags' source to work
"let g:deoplete#tag#cache_limit_size = 200000000

let g:deoplete#sources = {}
let g:deoplete#sources.cpp = ['buffer', 'member', 'file', 'around', 'filesrc']
let g:deoplete#ignore_sources = {}
let g:deoplete#ignore_sources._ = ['filesrc']
let g:deoplete#ignore_sources.cpp = []
"autocmd VimEnter * call deoplete#initialize()

" Unite
call unite#custom#profile('default', 'context', {
\	'direction': 'dynamicbottom',
\	'cursor_line_time': '0.0',
\	'prompt_direction': 'top',
\	'auto_resize': 1,
\	'select': '1'
\ })
" Custom mappings for the unite buffer
autocmd FileType unite call s:unite_settings()
function! s:unite_settings()
	nmap <buffer> p <Plug>(unite_toggle_auto_preview)
	nmap <buffer> <Esc> <Plug>(unite_exit)
	imap <buffer> <Tab> <C-x><Down>
	imap <buffer> <S-Tab> <C-x><Up>
	" Disable cursor looping
	silent! nunmap <buffer> <Up>
	silent! nunmap <buffer> <Down>
	" Unmap keys defined globally
	silent! nunmap <buffer> <C-p>
	silent! iunmap <buffer> <C-p>
	hi! link CursorLine PmenuSel
endfunction
call unite#custom#source('file,file/new,file_list,buffer', 'matchers',
	\'matcher_fuzzy')
call unite#custom#source('file,file/new,file_list,buffer', 'sorters',
	\'sorter_rank')

" indentLine
let g:indentLine_enabled = 0
let g:indentLine_faster = 1
let g:indentLine_color_term = 252

" neomake
if filereadable("./.neomake_cfg.vim")
	silent source ./.neomake_cfg.vim
endif
autocmd! VimLeave * let g:neomake_verbose = 0
let g:neomake_error_sign = {'text': '>>', 'texthl': 'NeomakeErrorSign'}
let g:neomake_warning_sign = {'text': '**', 'texthl': 'NeomakeWarningSign'}
let g:neomake_message_sign = {'text': '==', 'texthl': 'NeomakeMessageSign'}
let g:neomake_info_sign = {'text': '--', 'texthl': 'NeomakeInfoSign'}

let g:bufnr_to_num_jobs = {}

function! StartNeomakeJob()
	let g:bufnr_to_num_jobs[bufnr('%')] = 1
	redrawstatus!
	silent exec 'Neomake'
endfunction

function! FinishNeomakeJob()
	if g:neomake_hook_context.jobinfo.file_mode != 1
		return
	endif
	let l:buf = g:neomake_hook_context.jobinfo.bufnr
	if has_key(g:bufnr_to_num_jobs, l:buf)
		unlet g:bufnr_to_num_jobs[l:buf]
		redrawstatus!
	else
		echoerr "No key " . l:buf . " in g:bufnr_to_num_jobs!"
	endif
endfunction

augroup neomake_hooks
	au!
	autocmd User NeomakeJobFinished call FinishNeomakeJob()
augroup END

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
		let g:cur_prj_ctags = cur_prj_meta_root . "/tags"
		let g:cur_prj_completions = cur_prj_meta_root . "/completions"
		let g:deoplete#filesrc#path = g:cur_prj_completions

		" The following line is needed for project files opener key mapping
		let g:cur_prj_files = cur_prj_meta_root . "/files"

		" The following line specifies the IDs db path
		let g:unite_ids_db_path = cur_prj_meta_root . "/ID"

		exec "set tags=" . g:cur_prj_ctags . ";"
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

" Word navigation
nnoremap <C-Left> b
nnoremap <C-Right> w

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

" Move from the neovim terminal window to other neovim windows
tnoremap <S-Left> <C-\><C-n><C-w><Left>
tnoremap <S-Right> <C-\><C-n><C-w><Right>
tnoremap <S-Up> <C-\><C-n><C-w><Up>
tnoremap <S-Down> <C-\><C-n><C-w><Down>

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

function! DupLeft()
	let l:cur_wnd = winnr()
	let l:cur_view = winsaveview()
	let l:cur_buf = bufnr('%')
	exec "wincmd h"
	if winnr() == l:cur_wnd
		exec "wincmd v"
		exec "wincmd l"
		exec "b " . l:cur_buf
		call winrestview(l:cur_view)
		exec "wincmd h"
	else
		exec "b " . l:cur_buf
		call winrestview(l:cur_view)
	endif
endfunction
nnoremap » :call DupLeft()<CR>

" Open a fzf.vim window with the specified layout.
function! FzfWindow(layout, fzf_cmd, reverse)
	if exists("g:fzf_layout")
		let l:saved_layout = g:fzf_layout
	endif
	if a:reverse != 0
		let $FZF_DEFAULT_OPTS = '--reverse --bind=tab:down'
	else
		let $FZF_DEFAULT_OPTS = '--bind=tab:down'
	endif
	let g:fzf_layout = a:layout
	exec a:fzf_cmd
	if exists("l:saved_layout")
		let g:fzf_layout = l:saved_layout
	else
		unlet g:fzf_layout
	endif
endfunction

function! StartOrCloseUnite(unite_cmd)
	let unite_winnr = unite#get_unite_winnr('default')
	if unite_winnr > 0
		exec "Unite -toggle"
	else
		exec a:unite_cmd
	endif
endfunction

" Returns the command to toggle the specified unite window.
function! StartOrCloseUniteCallCmd(unite_cmd)
	return ':call StartOrCloseUnite("' . a:unite_cmd . '")<CR>'
endfunction

" F1 - toggle location window
function! ToggleLocationWindow()
	let l:cur_wnd = winnr()
	let l:last_winnr = winnr('$')
	lclose
	if l:last_winnr == winnr('$')
		" No local location window has been closed
		"windo if &buftype == "quickfix" || &buftype == "locationlist"
		"	\ | lclose | endif
		"exec l:cur_wnd . "wincmd w"
		botright lopen
	endif
endfunction
nnoremap <silent> <F1> :call ToggleLocationWindow()<CR>
inoremap <silent> <F1> <Esc>:call ToggleLocationWindow()<CR>

" F2 - search tag
function! SearchCmd(searcher, prompt)
	if !exists('g:cur_prj_ctags')
		return ':echo "No ctags file!"<CR>'
	endif
	return ':call fzf#run({"source":"cat ' . g:cur_prj_completions . '",
		\"sink":"' . a:searcher . '",
		\"window":"aboveleft new",
		\"options":"--reverse --bind=tab:down --prompt=\"' . a:prompt . '\""})
		\<CR>'
endfunction

let s:search_tag_cmd = SearchCmd("FT", "Tag> ")
exec 'nnoremap <silent> <F2> ' . s:search_tag_cmd
exec 'inoremap <silent> <F2> <Esc>' . s:search_tag_cmd

" Shift-F2 - search word in the ID database (case sensitive)
let s:search_id_cmd = SearchCmd("FWC", "Word> ")
exec 'nnoremap <silent> <S-F2> ' . s:search_id_cmd
exec 'inoremap <silent> <S-F2> <Esc>' . s:search_id_cmd

" Cmd-F2 - search lines in the current buffer
function! BLinesWindow()
	exec 'let layout = { "window":"below ' .
		\float2nr(round(winheight('%') * 0.4)) .
		\'new" }'
	call FzfWindow(layout, 'call fzf#vim#buffer_lines("",
		\ { "options": "--bind=tab:down" })', 0)
endfunction
nnoremap <silent> <M-F2> :call BLinesWindow()<CR>
inoremap <silent> <M-F2> <Esc>:call BLinesWindow()<CR>

" F3 - browse buffers
let s:f3_cmd = StartOrCloseUniteCallCmd('Unite -previewheight=100 buffer')
exec 'nnoremap <silent> <F3> ' . s:f3_cmd
exec 'inoremap <silent> <F3> <Esc>' . s:f3_cmd
exec 'tnoremap <silent> <F3> <C-\><C-n>' . s:f3_cmd

" Cmd-F3 - commands history
nnoremap <silent> <M-F3> :History:<CR>
inoremap <silent> <M-F3> <Esc>:History:<CR>

" Shift-F7 - toggle indent guides
nmap <S-F7> :IndentLinesToggle<CR>
imap <S-F7> <C-o>:IndentLinesToggle<CR>

" F7 - toggle color column
function! ToggleColorColumn()
  if &colorcolumn == 0
    set colorcolumn=80
  else
    set colorcolumn=0
  endif
endfunction
nnoremap <F7> :call ToggleColorColumn()<CR>
inoremap <F7> <C-o>:call ToggleColorColumn()<CR>

" F8 - clear highlight of the last search until the next search
nnoremap <F8> :noh<CR>
inoremap <F8> <C-o>:noh<CR>

" F9 - history
let g:history_layout = { "down":"~40%" }
nnoremap <silent> <F9> :call FzfWindow(g:history_layout, "History", 1)<CR>
inoremap <silent> <F9> <Esc>:call FzfWindow(g:history_layout, "History", 1)<CR>

" Cmd-F9|F10 - backward/forward jump stack navigation
nnoremap <M-F9> <C-o>
nnoremap <M-F10> <C-i>
inoremap <M-F9> <C-o><C-o>
inoremap <M-F10> <C-o><C-i>

" F10 - browse buffer tags
nnoremap <F10> :call fzf#vim#buffer_tags('',
	\ { 'options': '--bind=tab:down' })<CR>
inoremap <F10> <Esc>:call fzf#vim#buffer_tags('',
	\ { 'options': '--bind=tab:down' })<CR>

" Shift-F10 - browse all tags
let g:nvimp_fzf_tags_layout = { "down":"~40%" }
nnoremap <S-F10> :call FzfWindow(g:nvimp_fzf_tags_layout, "Tags", 1)<CR>
inoremap <S-F10> <Esc>:call FzfWindow(g:nvimp_fzf_tags_layout, "Tags", 1)<CR>

" F11 - toggle default Unite window
function! ToggleUniteWindow()
	let unite_winnr = unite#get_unite_winnr('default')
	if unite_winnr > 0
		exec unite_winnr . "wincmd w"
		let g:last_unite_view = winsaveview()
		exec "Unite -toggle"
	else
		exec "UniteResume"
		if exists("g:last_unite_view")
			call winrestview(g:last_unite_view)
		endif
	endif
endfunction
nnoremap <F11> :call ToggleUniteWindow()<CR>
inoremap <F11> <Esc>:call ToggleUniteWindow()<CR>

" F12 - find definitions of the word under cursor
let s:f12_cmd = StartOrCloseUniteCallCmd('Unite -previewheight=100 tselect')
exec 'nnoremap <silent> <F12> ' . s:f12_cmd
exec 'inoremap <silent> <F12> <Esc>' . s:f12_cmd

" Shift-F12 - find references to the word under cursor using lid (IDs db)
let s:s_f12_cmd = StartOrCloseUniteCallCmd(
	\'Unite -previewheight=100 id/lid:<C-r><C-w>:-w')
exec 'nnoremap <silent> <S-F12> ' . s:s_f12_cmd
exec 'inoremap <silent> <S-F12> <Esc>' . s:s_f12_cmd

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
exec 'nnoremap <silent> <C-p> ' . s:ctrl_p_cmd
exec 'inoremap <silent> <C-p> <Esc>' . s:ctrl_p_cmd

"------------------------------------------------------------------------------
" Custom commands
"------------------------------------------------------------------------------

" F - find a pattern in the IDs database (case insensitive)
command! -nargs=1 -complete=tag F :Unite -previewheight=100
	\ id/lid:<args>:-r\ -i

" FW - find an exact word in the IDs database (case insensitive)
command! -nargs=1 -complete=tag FW :Unite -previewheight=100
	\ id/lid:<args>:-w\ -i

" FC - find a pattern in the IDs database (case sensitive)
command! -nargs=1 -complete=tag FC :Unite -previewheight=100 id/lid:<args>:-r

" FWC - find an exact word in the IDs database (case sensitive)
command! -nargs=1 -complete=tag FWC :Unite -previewheight=100 id/lid:<args>:-w
" ...and alias:
command! -nargs=1 -complete=tag FCW :Unite -previewheight=100 id/lid:<args>:-w

" FT - find an exact word in the tags database (case insensitive)
command! -nargs=1 -complete=tag FT :Unite -previewheight=100 tselect:^<args>$

" FTE - match an expression in the tags database
command! -nargs=1 -complete=tag FTE :Unite -previewheight=100 tselect:<args>

" Up - update project metadata
command! -nargs=0 Up :call s:update_project()

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

" Disable line numbers and color column in quickfix window.
autocmd FileType qf setlocal nonumber colorcolumn=

" Jump to the last position when reopening a file
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") |
	\ exe "normal! g'\"" | endif

" Highlight lines >= 80 chars and trailing whitespaces
function! HighlightFormatting()
  if &filetype == 'cpp' || &filetype == 'c' || &filetype == 'proto' ||
  \ &filetype == 'python' || &filetype == 'cmake' || &filetype == 'vim' ||
  \ &filetype == 'javascript' || &filetype == 'java'
"    highlight OverLength ctermbg=red ctermfg=white
"    match OverLength /\%80v.\+/
    highlight WhiteSpaceEOL ctermbg=gray
    2match WhiteSpaceEOL /\s\+$/
  endif
endfunction
autocmd BufNewFile,BufReadPost,WinEnter * call HighlightFormatting()

" Automatically enter insert mode in terminal window
autocmd BufWinEnter,WinEnter term://* startinsert

set timeoutlen=1000 ttimeoutlen=0

" Enable syntax highlighting. In iTerm2, select 'Light Background' palette.
syntax on
colorscheme my_colors_light

" Status line
function! BufNeomakeStat()
	if has_key(g:bufnr_to_num_jobs, bufnr('%'))
		return '@ '
	endif
	return ''
endfunction

highlight BufNeomakeStat ctermfg=LightBlue ctermbg=Black cterm=bold
set statusline=%#BufNeomakeStat#%{BufNeomakeStat()}
	\%*%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P

" Restore the previous session, if required
function! RestoreSession()
	silent source ./Session.vim
	" The following command still does not fully work if there are split
	" windows with different buffers. Need to figure out a better solution.
	windo filetype detect
endfunction
if @% == '' && filereadable("./Session.vim")
	autocmd VimEnter * call RestoreSession()
endif
