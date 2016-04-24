" ---------- NeoBundle Scripts ----------
" Note: Skip initialization for vim-tiny or vim-small.
if 0 | endif

if has('vim_starting')
  if &compatible
    set nocompatible               " Be iMproved
  endif

  " Required:
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('~/.vim/bundle'))

" Required:
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimproc.vim', {
\ 'build' : {
\     'windows' : 'tools\\update-dll-mingw',
\     'cygwin' : 'make -f make_cygwin.mak',
\     'mac' : 'make -f make_mac.mak',
\     'linux' : 'make',
\     'unix' : 'gmake',
\    },
\ }
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'plasticboy/vim-markdown'
" NeoBundle 'tpope/vim-rails'

call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
" ---------- End NeoBundle Scripts ----------

" ---------- NeoComplete Scripts ----------
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
  return neocomplete#close_popup() . "\<CR>"
endfunction

" <BS>: close popup and delete backword char.
inoremap <expr> <BS> neocomplete#smart_close_popup()."\<C-h>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" includeはneoincludeに分離されたっぽい？

" if has("mac")
"   let g:neocomplete#sources#include#paths = {
"         \ 'cpp': '.,/Library/Developer/CommandLineTools/usr/include/c++/v1,/usr/local/include,/usr/include',
"         \ 'c':   '.,/usr/local/include,/usr/include',
"         \ }
" elseif has("unix")
"   let g:neocomplete#sources#include#paths = {
"         \ 'cpp': '.,/usr/include/c++/4.9,/usr/local/include,/usr/include',
"         \ 'c':    '.,/usr/local/include,/usr/include',
"         \ }
" endif

" let g:neocomplete#sources#include#patterns = {
"       \ 'cpp':  '^\s*#\s*include',
"       \ 'c':    '^\s*#\s*include',
"       \ }
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

" 単語単位からパス単位で削除するように変更
autocmd FileType unite imap <silent><buffer> <C-w> <Plug>(unite_delete_backward_path)
" ESCキーを押すと終了する
autocmd FileType unite nmap <silent><buffer> <ESC> <Plug>(unite_exit)
" ウィンドウを分割して開く
autocmd FileType unite inoremap <silent><buffer><expr> <C-J> unite#do_action('split')
" ウィンドウを縦に分割して開く
autocmd FileType unite inoremap <silent><buffer><expr> <C-K> unite#do_action('vsplit')

" enable mru in /mnt
let g:neomru#file_mru_ignore_pattern = substitute(g:neomru#file_mru_ignore_pattern, '|\/mnt\/\\', '', '')
" ---------- End Unite Scripts ----------

" ---------- Vim-Markdown Scripts ----------
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_no_default_key_mappings = 1
" ---------- End Vim-Markdown Scripts ----------

" ---------- User Scripts ----------
set nu                  " number
syntax on
filetype plugin indent on
set ts=2 sw=0 sts=-1 et " tabstop shiftwidth softtabstop expandtab
set is hls ic           " incsearch hlsearch ignorecase
set sm mat=0            " showmatch matchtime=0
set bs=indent,eol,start
set fencs=ucs-bom,utf-8,iso-2022-jp,sjis,cp932,euc-jp,cp20932
set ffs=unix,dos,mac
set ls=2
set stl=%(%r\ %)%f%(\ %m%)%=%(%{&ff}\ \|\ %)%(%{&fenc}\ \|\ %)%(%{&ft}\ \|\ %)%(%p%%\ \|\ %)%(%l/%L:%c\ %)
set completeopt=menuone

" http://qiita.com/s_of_p/items/b61e4c3a0c7ee279848a
augroup reopen
  autocmd!
  autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
augroup END

" コメント行の継続を無効化
autocmd FileType * setlocal formatoptions-=ro
" ---------- End User Scripts ----------
