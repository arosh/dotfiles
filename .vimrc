set mouse=a " マウス機能を有効にする(Terminal.appでは使用不可)

syntax on
set hlsearch

filetype plugin indent on

" カーソル位置を復元する設定は消しました

" XMLの閉じタグ設定
augroup MyXML
  autocmd!
  autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
  autocmd Filetype html inoremap <buffer> </ </<C-x><C-o>
augroup END

" コンマの後に自動的にスペースを挿入
"inoremap , ,<Space>
" 保存時に行末の空白を除去する
" autocmd BufWritePre * :%s/\s\+$//ge
" 保存時にtabをスペースに変換する
" autocmd BufWritePre * :%s/\t/  /ge

set nocompatible
set backspace=indent,eol,start
set history=1000 " デフォルト値は20

" view
" set title
set number
"set ts=4 sw=4 sts=0
"set noexpandtab
set ts=4 sw=2 sts=2
set expandtab
set showcmd
set wildmenu
set nowrap " 長い文字列は折り返して表示するのを無効にする
set textwidth=0 " 自動折り返しを無効にする

" 80文字付近にバーを表示する設定
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
set wrapscan " 自動で折り返さない

set nobackup
" 変更されたら自動で再読み込み
set autoread
" vim終了後コンソール画面復元
set restorescreen

set termencoding=utf-8
set encoding=utf-8
set fileencoding=utf-8

" □とか○の文字があってもカーソル位置がずれないようにする
" なぜか効かない@Terminal.app
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
