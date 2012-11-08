set mouse=a

syntax on
set hlsearch

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

  set autoindent  " always set autoindenting on

endif " has("autocmd")


" XMLの閉じタグ設定
augroup MyXML
  autocmd!
  autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
  autocmd Filetype html inoremap <buffer> </ </<C-x><C-o>
augroup END

" コンマの後に自動的にスペースを挿入
"inoremap , ,<Space>
" 保存時に行末の空白を除去する
autocmd BufWritePre * :%s/\s\+$//ge
" 保存時にtabをスペースに変換する
" autocmd BufWritePre * :%s/\t/  /ge

set nocompatible
set backspace=indent,eol,start
set history=50

" view
" set title
set number
"set ts=4 sw=4 sts=0
"set noexpandtab
set ts=4 sw=2 sts=2
set expandtab
set showcmd
set wildmenu
set nowrap
set noruler
" 自動折り返し
set textwidth=0
" set textwidth=80
" if exists('&colorcolumn')
"   set colorcolumn=+1
" endif

set showmatch
set matchtime=0
set laststatus=2
set statusline=%f%m%r%=\ %Y:%{&fenc}:%{&ff}\ %l/%L\ %p%%

" search
set incsearch
set ignorecase
set smartcase
nmap <ESC><ESC> :<C-u>nohlsearch<CR>
set wrapscan

set nobackup
" 変更されたら自動で再読み込み
set autoread
" vim終了後コンソール画面復元
set restorescreen

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
autocmd BufNewFile,BufRead *.pde set filetype=java

" HTML向けの「ファイル名の上でgf もどるときはCtrl+^」に関する設定
autocmd FileType html setlocal includeexpr=substitute(v:fname,'^\\/','','') | setlocal path+=;/

" rubyが重い…
" let g:ruby_path = ""

" i_Ctrl-Aを無効にする (:help insert-indexを参照)
imap <C-a> a

" http://www.slideshare.net/tsukkee/vim5-vimrc
if filereadable(expand('~/.vimrc.neocomplcache'))
  source ~/.vimrc.neocomplcache
endif

if filereadable(expand('~/.vimrc.neobundle'))
  source ~/.vimrc.neobundle
endif

if filereadable(expand('~/.vimrc.misc'))
  source ~/.vimrc.misc
endif
