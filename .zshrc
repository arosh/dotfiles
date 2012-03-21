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
autoload colors
colors

MAIN_COLOR=${fg[red]}
CHANGE_COLOR=${fg[cyan]}

# /home/name/ => %/
case ${UID} in
0)
    PROMPT="%{$CHANGE_COLOR%}$(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') %B%{$MAIN_COLOR%}%/#%{${reset_color}%}%b "
    PROMPT2="%B%{$MAIN_COLOR%}%_>%{${reset_color}%}%b "
    ;;
*)
	PROMPT="%{$MAIN_COLOR%}%/%%%{${reset_color}%} "
    PROMPT2="%{$MAIN_COLOR%}%_%%%{${reset_color}%} "
    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && 
        PROMPT="%{$CHANGE_COLOR%}$(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') ${PROMPT}"
    ;;
esac

### opt 関係 ###

# auto change directory
#
setopt auto_cd

# auto directory pushd that you can get dirs list by cd -[tab]
#
setopt auto_pushd

# auto_pushdで、重複したディレクトリは記録しない
setopt pushd_ignore_dups

# no remove postfix slash of command line
#
setopt noautoremoveslash

# no beep sound when complete list displayed
#
setopt nolistbeep

# 複数リダイレクト
setopt multios

# correct無効
unsetopt correct

# ファイル候補の後ろに、種別を表す記号(ls -Fと同じ)
setopt list_types

# http://www-utheal.phys.s.u-tokyo.ac.jp/~yuasa/wiki/index.php/zsh%E3%81%AE%E4%BD%BF%E3%81%84%E6%96%B9
# 改行コードのない出力も一応表示
unsetopt promptcr

# 右プロンプトが邪魔になったら消す
setopt transient_rprompt

## Keybind configuration
#
# emacs like keybind (e.x. Ctrl-a gets to line head and Ctrl-e gets
#   to end) and something additions
#
bindkey -e

# historical backward/forward search with linehead string binded to ^P/^N
#
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end

bindkey '^R' history-incremental-pattern-search-backward
bindkey '^S' history-incremental-pattern-search-forward

## Command history configuration
#
HISTFILE=${HOME}/.zsh_history
HISTSIZE=50000 # メモリ上に保存
SAVEHIST=50000 # ファイルに保存
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data


## Completion configuration
fpath=(${HOME}/.zsh/functions/Completion ${fpath})
autoload -U compinit
compinit

# ls した時に詰めて表示
setopt list_packed

# ワイルドカードとかの拡張
setopt extended_glob

# 数式展開とかしてくれるらしい
setopt prompt_subst

# あいまい補完で、補完+リスト表示
unsetopt list_ambiguous

# = 以降でも補完できるようにする( --prefix=/usr 等の場合)
setopt magic_equal_subst

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
#zstyle ':completion:*' completer _oldlist _complete _match _history _ignored _approximate _prefix


## 補完候補をキャッシュする。
zstyle ':completion:*' use-cache yes
## 詳細な情報を使う。
#zstyle ':completion:*' verbose yes
## sudo時にはsudo用のパスも使う。
#zstyle ':completion:sudo:*' environ PATH="$SUDO_PATH:$PATH"

## カーソル位置で補完する。
setopt complete_in_word
## globを展開しないで候補の一覧から補完する。
#setopt glob_complete
## 補完時にヒストリを自動的に展開する。
#setopt hist_expand
## 補完候補がないときなどにビープ音を鳴らさない。
#setopt no_beep
## 辞書順ではなく数字順に並べる。
setopt numeric_glob_sort

## Alias configuration
#
# expand aliases before completing
#
#setopt complete_aliases     # aliased ls needs if file/dir completions work
# alias のオプションを補完 on なのか off なのかよくわからん。。。
unsetopt complete_aliases

#alias where="command -v"
#alias j="jobs -l"

case "${OSTYPE}" in
freebsd*|darwin*)
    alias ls="ls -G -w -p"
    ;;
linux*)
    alias ls="ls --color -p"
    ;;
esac

alias l="ls"
alias la="ls -a"
alias ll="ls -lh"
alias lla="ls -lah"
alias rmdir="rm -rf"

alias cp="cp -i"

alias grep="grep --color=auto"

# 環境変数を解除
alias su="su -l"

# rm * を確認する
setopt rm_star_wait

## ページャーを使いやすくする。
### grep -r def *.rb L -> grep -r def *.rb |& lv
# alias -g @L="|& $PAGER"
## grepを使いやすくする。
# alias -g @G='| grep'

## load user .zshrc configuration file
#
[ -f ${HOME}/.zshrc.mine ] && source ${HOME}/.zshrc.mine
[ -f ${HOME}/.zshrc.osx ] && source ${HOME}/.zshrc.osx

