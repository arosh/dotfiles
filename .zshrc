setopt prompt_subst  # PROMPT変数の中の文字列を展開する (おまじない)
autoload -Uz colors; colors # プロンプトのカラー化

# MAIN_COLOR=${fg[red]}
# CHANGE_COLOR=${fg[cyan]}
#
# # /home/name/ => %/
# case ${UID} in
# 0)
#     PROMPT="%{$CHANGE_COLOR%}$(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') %B%{$MAIN_COLOR%}%/#%{${reset_color}%}%b "
#     PROMPT2="%B%{$MAIN_COLOR%}%_>%{${reset_color}%}%b "
#     ;;
# *)
#     PROMPT="%{$MAIN_COLOR%}%/%%%{${reset_color}%} "
#     PROMPT2="%{$MAIN_COLOR%}%_%%%{${reset_color}%} "
#     [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
#         PROMPT="%{$CHANGE_COLOR%}$(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') ${PROMPT}"
#     ;;
# esac

# http://shellscript.sunone.me/if_and_test.html
if [ -n "${REMOTEHOST}${SSH_CONNECTION}" ]; then
  PROMPT="%{$fg[green]%}$(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') %{$fg[cyan]%}%/%{$reset_color%} "
else
  PROMPT="%{$fg[red]%}%/%{$reset_color%} "
fi

# lsの色付け設定
# BSD
export LSCOLORS=exfxcxdxbxegedabagacad
# GNU
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
# 補完用
zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'

## 補完候補に色を付ける。
### "": 空文字列はデフォルト値を使うという意味。
#zstyle ':completion:*:default' list-colors ""
#zstyle ':completion:*' list-colors \
#  $(dircolors -b | sed -e "s/'//" -e "s/^LS_COLORS=//" | head -n 1 | tr : ' ')


# setopt auto_cd            # ディレクトリ名だけで移動
# setopt auto_pushd         # cdしたディレクトリを自動でpushd (cd -で呼び出せる)
# setopt pushd_ignore_dups  # auto_pushdで、重複したディレクトリは記録しない
setopt auto_param_slash     # ディレクトリ名の末尾に自動的に/を追加
setopt nolistbeep           # 補完時にビープを鳴らさない
setopt multios              # 複数リダイレクトを有効にする
setopt notify               # バックグラウンドジョブの状態変化を即時報告する
# unsetopt correct          # correct無効
setopt list_types # 補完時のファイルの後ろに種別を表す記号(ls -Fと同じ)

# http://www-utheal.phys.s.u-tokyo.ac.jp/~yuasa/wiki/index.php/zsh%E3%81%AE%E4%BD%BF%E3%81%84%E6%96%B9
# CRで終わる行でも一応改行
unsetopt promptcr

setopt transient_rprompt # 右プロンプトが邪魔になったら消す

bindkey -e # emacs kaybind

# historical backward/forward search with linehead string binded to ^P/^N
#
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end

# bindkey '^R' history-incremental-pattern-search-backward
# bindkey '^S' history-incremental-pattern-search-forward

## Command history configuration
#
HISTFILE=${HOME}/.zsh_history
HISTSIZE=50000 # メモリ上に保存
SAVEHIST=50000 # ファイルに保存
setopt hist_ignore_dups     # 重複した履歴を保存しない (直前のものと同じ時だけ)
setopt share_history        # share command history data
setopt extended_history     # 履歴ファイルに時刻を記録
setopt hist_ignore_space    # スペースで始まるコマンド行はヒストリリストから削除


## Completion configuration
# fpath=(${HOME}/.zsh/functions/Completion ${fpath}) # 自作補完ファイル
autoload -Uz compinit
compinit

setopt list_packed   # ls した時に詰めて表示
setopt extended_glob # ワイルドカードとかの拡張 (~で否定など)

# あいまい補完で、補完+リスト表示
#unsetopt list_ambiguous

# = 以降でも補完できるようにする( --prefix=/usr 等の場合)
setopt magic_equal_subst

# http://www.clear-code.com/blog/2011/9/5.html
## 補完侯補をメニューから選択する。
### select=2: 補完候補を一覧から選択する。
###           ただし、補完候補が2つ以上なければすぐに補完する。
zstyle ':completion:*:default' menu select=2
# setopt auto_list
# setopt auto_menu
bindkey "[Z" reverse-menu-complete  # Shift-Tabで補完候補を逆順する (Ctrl+v Shift+Tabで入力した)


# 補完の時に大文字小文字を区別しない(但し、大文字を打った場合は小文字に変換しない)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# sudo でも補完の対象
# zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin

## 補完候補をキャッシュする。
zstyle ':completion:*' use-cache true


setopt complete_in_word   # カーソル位置で補完する。
# setopt glob_complete    # globを展開しないで候補の一覧から補完する。
# setopt hist_expand      # 補完時にヒストリを自動的に展開する。
setopt numeric_glob_sort  # 辞書順ではなく数字順に並べる。

setopt rm_star_wait # rm * を確認する

# http://memo.officebrook.net/20100223.html
# alias元の補完を使用する。 unsetで正しい
unsetopt complete_aliases

# 追加の設定を読み込む
# `uname` を使う？
[ -f ${HOME}/.zshrc.mine ] && source ${HOME}/.zshrc.mine
[ -f ${HOME}/.zshrc.alias ] && source ${HOME}/.zshrc.alias
# http://mimosa-pudica.net/zsh-incremental.html
# [ -f ${HOME}/incr-0.2.zsh ] && source ${HOME}/incr-0.2.zsh
