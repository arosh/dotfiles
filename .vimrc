set nocompatible
set backspace=indent,eol,start

set history=50		" keep 50 lines of command line history
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

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
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" XMLの閉じタグ設定
augroup MyXML
  autocmd!
  autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
  autocmd Filetype html inoremap <buffer> </ </<C-x><C-o>
augroup END

set number
set ignorecase
set smartcase
"set ts=4 sw=4 sts=0
"set noexpandtab
set ts=4 sw=2 sts=2
set expandtab
nmap <ESC><ESC> :nohlsearch<LF>

set wildmenu
" set title
set nowrap
set noruler
set wrapscan
set textwidth=0

set showmatch
set matchtime=0

set backup
set backupdir=$HOME/.vimbackup

set laststatus=2
set statusline=%f%m%r%=\ %Y:%{&fenc}:%{&ff}\ %l/%L\ %p%%

set termencoding=utf-8
set encoding=utf-8
set fileencoding=utf-8

" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif

"改行コード
set fileformats=unix,dos,mac

" コメント行の継続を無効化
autocmd FileType * setlocal formatoptions-=r
autocmd FileType * setlocal formatoptions-=o

" ファイルタイプの指定
autocmd BufNewFile,BufRead *.scala set filetype=scala
autocmd BufNewFile,BufRead *.sbt set filetype=scala
autocmd BufNewFile,BufRead *.ru set filetype=ruby
autocmd BufNewFile,BufRead *.md set filetype=markdown

source ~/.vimrc.neocomplcache
source ~/.vimrc.neobundle
