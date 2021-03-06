" Personal basic options
set number

let mapleader = "¸"

inoremap jk <esc>

" inoremap <left>		<nop>
" inoremap <right>	<nop>
" inoremap <up>		<nop>
" inoremap <down>		<nop>
" nnoremap <left>		<nop>
" nnoremap <right>	<nop>
" nnoremap <up>		<nop>
" nnoremap <down>		<nop>

nnoremap <F3> :set hlsearch!<CR>

" Enable google calendar
let g:calendar_google_task = 1



" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2014 Feb 05
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file (restore to previous version)
  set undofile		" keep an undo file (undo changes after closing)
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" Pathogen package manegment system call
call pathogen#infect()
call pathogen#helptags()


"=====[ Highlight matches when jumping to next ]=============

    " This rewires n and N to do the highlighing...
    nnoremap <silent> n   n:call HLNext(0.4)<cr>
    nnoremap <silent> N   N:call HLNext(0.4)<cr>

    " OR ELSE just highlight the match in red...
    function! HLNext (blinktime)
        let [bufnum, lnum, col, off] = getpos('.')
        let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
        let target_pat = '\c\%#\%('.@/.'\)'
        let ring = matchadd('WhiteOnRed', target_pat, 101)
        redraw
        exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
        call matchdelete(ring)
        redraw
    endfunction

" Map Tab in Normal mode to Ctrl-^ (for switching windows)

nnoremap <Tab> <C-^>


" Syntastic recommended settings ------------------------------ {{{
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*

" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0


" Syntastic set passive mode
" let b:syntastic_mode = "passive"
" }}}


" Drag visuals key mapping ------------------------------ {{{
augroup dvb
	vmap  <expr>  <LEFT>   DVB_Drag('left')
	vmap  <expr>  <RIGHT>  DVB_Drag('right')
	vmap  <expr>  <DOWN>   DVB_Drag('down')
	vmap  <expr>  <UP>     DVB_Drag('up')
	vmap  <expr>  D        DVB_Duplicate()
augroup END
" }}}


" Remove any introduced trailing whitespace after moving... ------------------------------ {{{
augroup dvb
	let g:DVB_TrimWS = 1
augroup END
" }}}


" Quickly edit .vimrc ------------------------------ {{{
augroup vimrc
nnoremap <leader>ev :split $MYVIMRC<cr>
nnoremap <leader>sv :w<cr>:source $MYVIMRC<cr>:clo<cr>
augroup END
" }}}


" Surround word in quotes ------------------------------ {{{
augroup quotes
	nnoremap <leader>" viw<esc>a"<esc>hbi"<esc>lel
	vnoremap <leader>" <esc>a"<esc>`<i"<esc>lviw
augroup END
" }}}


" Markdown maps ------------------------------ {{{
augroup filetype_markdown
	onoremap ih :<c-u>execute "normal! ?^[-=]\\+$\r:nohlsearch\rkvg_"<cr>
	onoremap ah :<c-u>execute "normal! ?^[-=]\\+$\r:nohlsearch\rg_vk0"<cr>
augroup END
" }}}


" Vimscript file settings ----------------------- {{{
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
    iabbrev autog " ------------------------------ {{{<cr>
    		\augroup <cr>
    		\augroup END<cr>
    		\" }}}
augroup END
" }}}


" Java handler ------------------------------ {{{
augroup java
augroup END
" }}}


" Python file settings ------------------------------ {{{
augroup filetype_python
	nnoremap <leader>r :w<cr>:Start python3 %<cr>
augroup END
" }}} 
