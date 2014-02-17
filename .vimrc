" 分割画面の入れ替えはCtrl+W xで、直前のウィンドウと入れ替え

" imapは再帰的に展開される
" inoremapは再帰的には展開されない

" <C-u>はコマンドバッファを削除する
" 123<コマンド>で、コマンドが123回実行されないように
" http://d.hatena.ne.jp/abulia/20110502/1304334367

" マクロは q -> アルファベット1文字 で記録開始
" q で記録終了
" @アルファベットで呼び出し

" ``  直前の行(マーク)へ戻る
" マーク
" Ctrl-o  より古いマークへジャンプ
" Ctrl-i  より新しいマークへジャンプ
" ma  マークaを設定(a～z)
" `a  マークaにジャンプ
" 'a  マークaの行頭にジャンプ
" :marks  マーク一覧

" ctagsの使い方
" :!ctags -R でカレントディレクトリ以下の全てのファイルについてタグ生成
" Ctrl+] でジャンプ
" 戻るときは Ctrl-o か Ctrl-t
" Ctrl-oはjumplistで動く
" Ctrl-tはtags stackで動く

" make関係
" :makeでmakeする
" :cnでエラー先にジャンプ, :ccでエラーを再確認

" surround.vim
" d[delete]+s[surround]+[消したいもの]
" c[change]+s[surround]+[before]+[after]

set mouse=a " マウス機能を有効にする(Terminal.appでは使用不可)

syntax on
set hlsearch

filetype plugin indent on

" カーソル位置を復元する設定
autocmd BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif


" XMLの閉じタグ設定
augroup MyXML
  autocmd!
  " <buffer>を付けると、他のbufferでは無効になる(バッファローカル)
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
set textwidth=0 " 自動折り返しを無効にする

" set nowrap " 長い文字列は折り返して表示するのを無効にする
set wrap " 長い文字列は折り返して表示
" 折り返された文字列にも移動できるようにする
nnoremap j gj
nnoremap k gk
" nnoremap <Down> gj
" nnoremap <Up> gk

set showmatch
set matchtime=0
set laststatus=2
set statusline=%f%m%r%=\ %Y\ %{&fenc}\ %{&ff}\ %l/%L\ %p%%

" search
set incsearch
set ignorecase
set smartcase
nnoremap <ESC><ESC> :<C-u>nohlsearch<CR>
set wrapscan " 下まで行ったら、上に戻って検索する

set nobackup

" ucs-bom: BOMに書かれた設定に従う (最初に書くことを推奨)
" http://magicant.txt-nifty.com/main/2009/03/vim-modeline-fi.html
set fileencodings=ucs-bom,utf-8,iso-2022-jp,sjis,cp932,euc-jp,cp20932

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

" i_Ctrl-Aを無効にする (:help insert-indexを参照) 直前の文字列を入力する
inoremap <C-a> a

" http://www.slideshare.net/tsukkee/vim5-vimrc
if filereadable(expand('~/.vimrc.neobundle'))
  source ~/.vimrc.neobundle
endif

if filereadable(expand('~/.vimrc.misc'))
  source ~/.vimrc.misc
endif

if filereadable(expand('~/.vimrc.neocomplete'))
  source ~/.vimrc.neocomplete
endif
