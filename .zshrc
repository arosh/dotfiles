# users generic .zshrc file for zsh(1)

## Environment variable configuration
##
# LANG
#
export LANG=ja_JP.UTF-8
case ${UID} in
0)
    LANG=C
    ;;
esac


## Default shell configuration
#
# set prompt
#
autoload colors
colors
case ${UID} in
0)
    PROMPT="%{${fg[cyan]}%}$(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') %B%{${fg[red]}%}%/#%{${reset_color}%}%b "
    PROMPT2="%B%{${fg[red]}%}%_>%{${reset_color}%}%b "
    #SPROMPT="%B%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
    ;;
*)
    PROMPT="%{${fg[red]}%}%/%%%{${reset_color}%} "
    PROMPT2="%{${fg[red]}%}%_>%{${reset_color}%} "
    #SPROMPT="%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%} "
    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && 
        PROMPT="%{${fg[cyan]}%}$(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') ${PROMPT}"
    ;;
esac

# auto change directory
#
setopt auto_cd

# auto directory pushd that you can get dirs list by cd -[tab]
#
setopt auto_pushd

# auto_pushdで、重複したディレクトリは記録しない
setopt pushd_ignore_dups

# command correct edition before each completion attempt
#
#setopt correct

# compacked complete list display
#
setopt list_packed

# no remove postfix slash of command line
#
setopt noautoremoveslash

# no beep sound when complete list displayed
#
setopt nolistbeep

# = 以降でも補完できるようにする( --prefix=/usr 等の場合)
setopt magic_equal_subst

# ファイル候補の後ろに、種別を表す記号(ls -Fと同じ)
setopt list_types

# http://www-utheal.phys.s.u-tokyo.ac.jp/~yuasa/wiki/index.php/zsh%E3%81%AE%E4%BD%BF%E3%81%84%E6%96%B9
# 改行コードのない出力も一応表示
unsetopt promptcr

# ワイルドカードとかの拡張
setopt extended_glob

# 数式展開とかしてくれるらしい
setopt prompt_subst

## Keybind configuration
#
# emacs like keybind (e.x. Ctrl-a gets to line head and Ctrl-e gets
#   to end) and something additions
#
bindkey -e
# bindkey "^[[1~" beginning-of-line # Home gets to line head
# bindkey "^[[4~" end-of-line # End gets to line end
# bindkey "^[[3~" delete-char # Del

# historical backward/forward search with linehead string binded to ^P/^N
#
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end
# bindkey "\\ep" history-beginning-search-backward-end
# bindkey "\\en" history-beginning-search-forward-end

# reverse menu completion binded to Shift-Tab
#
# bindkey "\e[Z" reverse-menu-complete

## Command history configuration
#
HISTFILE=${HOME}/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data


## Completion configuration
#
fpath=(${HOME}/.zsh/functions/Completion ${fpath})
autoload -U compinit
compinit

# http://www.clear-code.com/blog/2011/9/5.html
## 補完侯補をメニューから選択する。
### select=2: 補完候補を一覧から選択する。
###           ただし、補完候補が2つ以上なければすぐに補完する。
zstyle ':completion:*:default' menu select=2

## 補完候補に色を付ける。
### "": 空文字列はデフォルト値を使うという意味。
#zstyle ':completion:*:default' list-colors ""

# 補完の時に大文字小文字を区別しない(但し、大文字を打った場合は小文字に変換しない)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'


## 補完方法の設定。指定した順番に実行する。
### _oldlist 前回の補完結果を再利用する。
### _complete: 補完する。
### _match: globを展開しないで候補の一覧から補完する。
### _history: ヒストリのコマンドも補完候補とする。
### _ignored: 補完候補にださないと指定したものも補完候補とする。
### _approximate: 似ている補完候補も補完候補とする。
### _prefix: カーソル以降を無視してカーソル位置までで補完する。
zstyle ':completion:*' completer _oldlist _complete _match _history _ignored _approximate _prefix


## 補完候補をキャッシュする。
zstyle ':completion:*' use-cache yes
## 詳細な情報を使う。
zstyle ':completion:*' verbose yes
## sudo時にはsudo用のパスも使う。
#zstyle ':completion:sudo:*' environ PATH="$SUDO_PATH:$PATH"

## カーソル位置で補完する。
setopt complete_in_word
## globを展開しないで候補の一覧から補完する。
setopt glob_complete
## 補完時にヒストリを自動的に展開する。
setopt hist_expand
## 補完候補がないときなどにビープ音を鳴らさない。
#setopt no_beep
## 辞書順ではなく数字順に並べる。
setopt numeric_glob_sort

## zsh editor
#
# autoload zed


## Prediction configuration
#
#autoload predict-on
#predict-off


## Alias configuration
#
# expand aliases before completing
#
setopt complete_aliases     # aliased ls needs if file/dir completions work

#alias where="command -v"
#alias j="jobs -l"

case "${OSTYPE}" in
freebsd*|darwin*)
    alias ls="ls -G -w"
    ;;
linux*)
    alias ls="ls --color"
    ;;
esac

alias l="ls"
alias la="ls -a"
alias lf="ls -F"
alias ll="ls -l"
alias lla="ls -la"

#alias du="du -h"
#alias df="df -h"

#alias su="su -l"

alias rm="rm -i"
alias mv="mv -i"
alias cp="cp -i"

## ページャーを使いやすくする。
### grep -r def *.rb L -> grep -r def *.rb |& lv
alias -g L="|& $PAGER"
## grepを使いやすくする。
alias -g G='| grep'

## terminal configuration
#
#case "${TERM}" in
#screen)
#    TERM=xterm
#    ;;
#esac
#
#case "${TERM}" in
#xterm|xterm-color)
#    export LSCOLORS=exfxcxdxbxegedabagacad
#    export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
#    zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
#    ;;
#kterm-color)
#    stty erase '^H'
#    export LSCOLORS=exfxcxdxbxegedabagacad
#    export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
#    zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
#    ;;
#kterm)
#    stty erase '^H'
#    ;;
#cons25)
#    unset LANG
#    export LSCOLORS=ExFxCxdxBxegedabagacad
#    export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
#    zstyle ':completion:*' list-colors 'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
#    ;;
#jfbterm-color)
#    export LSCOLORS=gxFxCxdxBxegedabagacad
#    export LS_COLORS='di=01;36:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
#    zstyle ':completion:*' list-colors 'di=;36;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
#    ;;
#esac

# set terminal title including current directory
#
#case "${TERM}" in
#xterm|xterm-color|kterm|kterm-color)
#    precmd() {
#        echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
#    }
#    ;;
#esac


## load user .zshrc configuration file
#
[ -f ${HOME}/.zshrc.mine ] && source ${HOME}/.zshrc.mine

