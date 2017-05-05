" ---------- Dein Scripts ----------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath^=~/.vim/dein/repos/github.com/Shougo/dein.vim

" Required:
call dein#begin(expand('~/.vim/dein'))

" Let dein manage dein
" Required:
call dein#add('Shougo/dein.vim')

" Add or remove your plugins here:
call dein#add('Shougo/vimproc.vim', {'build' : 'make'})
if has('lua')
  call dein#add('Shougo/neocomplete.vim')
endif
call dein#add('Shougo/unite.vim')
call dein#add('Shougo/neomru.vim')
call dein#add('vim-jp/vim-cpp', {'on_ft' : 'cpp'})
call dein#add('plasticboy/vim-markdown', {'on_ft' : 'markdown'})
call dein#add('davidhalter/jedi-vim', {'on_ft' : 'python'})
call dein#add('fatih/vim-go', {'on_ft' : 'go'})
if executable('racer')
  call dein#add('racer-rust/vim-racer', {'on_ft' : 'rust'})
endif

" Required:
call dein#end()

" Required:
filetype plugin indent on

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif
" ---------- End Dein Scripts ----------

" ---------- NeoComplete Scripts ----------
if has('lua')
  " Use neocomplete.
  let g:neocomplete#enable_at_startup = 1
  " Use smartcase.
  let g:neocomplete#enable_smart_case = 1
  " Set minimum syntax keyword length.
  let g:neocomplete#sources#syntax#min_keyword_length = 3
  let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

  " Define keyword.
  if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
  endif
  let g:neocomplete#keyword_patterns['default'] = '\h\w*'

  " Recommended key-mappings.
  " <CR>: close popup and save indent.
  inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
  function! s:my_cr_function()
    return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
  endfunction

  " <C-h>, <BS>: close popup and delete backword char.
  inoremap <expr> <C-h> neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr> <BS> neocomplete#smart_close_popup()."\<C-h>"

  " Enable omni completion.
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  " autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

  " Enable heavy omni completion.
  if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
  endif
  let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
  let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
  let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
endif " has('lua')
" ---------- End NeoComplete Scripts ----------

" ---------- Unite Scripts ----------
" 挿入モードで開始
call unite#custom#profile('default', 'context', { 'start_insert' : 1 })
" 1行目がスキップされないようにする
let g:unite_enable_auto_select = 0
" <C-u> : 繰り返し指定の数字 (5xで5文字消えるみたいなやつ) をリセットする
" ファイルがあるディレクトリでファイラを開く (開いていない時はカレントディレクトリ)
" directoryのデフォルトアクションになるべく合わせた
nnoremap <silent> <Leader>f :<C-u>UniteWithBufferDir file file/new directory/new -hide-source-names<CR>
" 最近使ったファイルを開く
nnoremap <silent> <Leader>r :<C-u>Unite file_mru<CR>

" Uniteのバッファ内専用の設定
" <Plug>を使うときには[in]noremapではなく[in]mapを使う
" <silent> : コマンドをコマンドラインに出力しない
" <buffer> : バッファローカルなキーマッピングにする
" <expr> : 式を評価した文字列にマップする

augroup unite
  autocmd!
  " 単語単位からパス単位で削除するように変更
  autocmd FileType unite imap <silent><buffer> <C-w> <Plug>(unite_delete_backward_path)
  " ESCキーを押すと終了する
  autocmd FileType unite nmap <silent><buffer> <ESC> <Plug>(unite_exit)
  " ウィンドウを分割して開く
  autocmd FileType unite inoremap <silent><buffer><expr> <C-J> unite#do_action('split')
  " ウィンドウを縦に分割して開く
  autocmd FileType unite inoremap <silent><buffer><expr> <C-K> unite#do_action('vsplit')
augroup END

" enable mru in /mnt
" let g:neomru#file_mru_ignore_pattern = substitute(g:neomru#file_mru_ignore_pattern, '|\/mnt\/\\', '', '')
" ---------- End Unite Scripts ----------

" ---------- Vim-Markdown Scripts ----------
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_no_default_key_mappings = 1
" ---------- End Vim-Markdown Scripts ----------

" ---------- Vim-Racer Scripts ----------
if executable('racer')
  let g:racer_cmd = '$HOME/.cargo/bin/racer'
  let g:racer_experimental_completer = 1
  augroup racer
    autocmd!
    autocmd FileType rust nmap gd <Plug>(rust-def)
    autocmd FileType rust nmap gs <Plug>(rust-def-split)
    autocmd FileType rust nmap gx <Plug>(rust-def-vertical)
    autocmd FileType rust nmap <leader>gd <Plug>(rust-doc)
  augroup END
endif
" ---------- End Vim-Racer Scripts ----------

" ---------- User Scripts ----------
set number
syntax on
filetype plugin indent on
" When 'shiftwidth' is zero, the value of 'ts' will be used.
" When 'softtabstop' is negative, the value of 'shiftwidth' will be used.
set tabstop=2 shiftwidth=0 softtabstop=-1 expandtab
set incsearch hlsearch ignorecase
set showmatch matchtime=0
set backspace=indent,eol,start
" http://magicant.txt-nifty.com/main/2009/03/vim-modeline-fi.html
set fileencodings=ucs-bom,utf-8,iso-2022-jp,sjis,cp932,euc-jp,cp20932
set fileformats=unix,dos,mac
set laststatus=2
set statusline=%(%r\ %)%f%(\ %m%)%=%(%{&ff}\ \|\ %)%(%{&fenc}\ \|\ %)%(%{&ft}\ \|\ %)%(%p%%\ \|\ %)%(%l/%L:%c\ %)
set completeopt=menuone

" http://qiita.com/s_of_p/items/b61e4c3a0c7ee279848a
" http://thinca.hatenablog.com/entry/20100205/1265307642
augroup vimrc
  autocmd!
  autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
  " コメント行の継続を無効化
  autocmd FileType * setlocal formatoptions-=ro
  " Makefile
  autocmd FileType make setlocal noexpandtab tabstop=4
  " Golang
  autocmd FileType go setlocal noexpandtab tabstop=4
augroup END

" http://d.hatena.ne.jp/seuzo/20090309/12365250901
" http://thinca.hatenablog.com/entry/20100201/1265009821
" http://deris.hatenablog.jp/entry/2013/05/15/024932
if hostname() =~# '\v(bda1node\d{2}|tesla\d|galaxy\d{2}|grid-dev\d)\.naist\.jp'
  " http://vimblog.hatenablog.com/entry/vimrc_key_mapping
  " http://ysmt.blog21.fc2.com/blog-entry-257.html
  " ^? みたいな文字は Ctrl+V -> BackSpace
  " ^H みたいな文字は Ctrl+V -> Ctrl+H
  noremap  
  noremap!  
endif
" ---------- End User Scripts ----------
