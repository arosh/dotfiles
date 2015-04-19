" ---------- NeoBundle Scripts ----------
" Note: Skip initialization for vim-tiny or vim-small.
if !1 | finish | endif

if has('vim_starting')
  set nocompatible               " Be iMproved

  " Required:
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('~/.vim/bundle'))

" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'Shougo/neocomplete.vim'
" NeoBundle 'Shougo/unite.vim'

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
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"

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

if has("mac")
  let g:neocomplete#sources#include#paths = {
        \ 'cpp': '.,/Library/Developer/CommandLineTools/usr/include/c++/v1,/usr/local/include,/usr/include',
        \ 'c':   '.,/usr/local/include,/usr/include',
        \ }
elseif has("unix")
  let g:neocomplete#sources#include#paths = {
        \ 'cpp': '.,/usr/include/c++/4.8,/usr/local/include,/usr/include',
        \ 'c':    '.,/usr/local/include,/usr/include',
        \ }
endif

let g:neocomplete#sources#include#patterns = {
      \ 'cpp':  '^\s*#\s*include',
      \ 'c':    '^\s*#\s*include',
      \ }
" ---------- End NeoComplete Scripts ----------

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
augroup vimrcEx
  autocmd!
  autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
augroup END

" コメント行の継続を無効化
autocmd FileType * setlocal formatoptions-=ro
" ---------- End User Scripts ----------
