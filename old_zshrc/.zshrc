# 運用ルール
# zshenvには，基本的には環境変数のみ書く。rbenvのように「zshenvに書け」と書いてある設定も書く。
# それ以外はzshrcに記述する。
# MacのZshにはPATHの内容をメチャクチャにする設定が書かれているので注意
# (brew info zshを参照)
#
# ログイン時       zshenv -> zprofile -> zshrc -> zlogin
# シェル起動時     zshenv -> zshrc
# スクリプト起動時 zshenv
# ログアウト時     zlogout

# autoload -> 関数を読み込む
# -U -> 関数内ではaliasを展開しない
# -z -> zshスタイルで書かれた関数を読み込む
# 何も考えずに-Uzを付けてOK

### 表示関連 ###

# $PROMPTの中に書かれた変数を，プロンプトを更新するごとに展開しなおす(vcs_infoに必要)
setopt prompt_subst

# 色を名前で指定できるようにする
autoload -Uz colors; colors

# プロンプトの表示
PROMPT="%{$fg[red]%}%/%{$reset_color%} "

# lsの色付け設定。漢のzshからパクった http://news.mynavi.jp/column/zsh/009/
# BSD
export LSCOLORS=exfxcxdxbxegedabagacad
# GNU
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
# 補完用
zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'

setopt auto_param_slash  # ディレクトリ名の末尾に自動的に/を追加
setopt nolistbeep        # 補完時にビープを鳴らさない
setopt list_types        # 補完時のファイルの後ろに種別を表す記号(ls -Fと同じ)
setopt notify            # バックグラウンドジョブの状態変化を即時報告する
setopt transient_rprompt # 右プロンプトが邪魔になったら消す
setopt multios           # 複数リダイレクトを有効にする
setopt list_packed       # ls した時に詰めて表示

# Unix規約では，シェルから呼び出したコマンドは\nを最後に出力しなければならないが，
# 出力しなかった場合には最終行は出力されない。
# この仕様はさすがに不便なので，\nで終わらなかったとしても表示するようにする。
# http://wiki.fdiary.net/zsh/?FAQ%40zsh%A5%B9%A5%EC#l1
unsetopt promptcr

### 操作関連 ###
bindkey -e # emacs kaybind

### ヒストリ関連 ###
HISTFILE=${HOME}/.zsh_history
HISTSIZE=50000 # メモリ上に保存
SAVEHIST=50000 # ファイルに保存
setopt share_history        # 同時に起動したzshの間でヒストリを共有する
setopt hist_ignore_all_dups # 重複した履歴を保存しない
setopt hist_ignore_space    # スペースで始まるコマンド行はヒストリに記録しない

autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end
bindkey "[Z" reverse-menu-complete  # Shift-Tabで補完候補を逆順する (Ctrl+v Shift+Tabで入力した)

### 補完関連 ###
autoload -Uz compinit; compinit

setopt extended_glob     # ワイルドカードとかの拡張 (~で否定など)
setopt magic_equal_subst # --prefix=/usr 等で=以降でも補完できるようにする

# http://www.clear-code.com/blog/2011/9/5.html
# 補完侯補をメニューから選択する。
# select=2: 補完候補を一覧から選択する。
#           ただし，補完候補が2つ以上なければすぐに補完する。
zstyle ':completion:*:default' menu select=2

# 補完の時に大文字小文字を区別しない(但し，大文字を打った場合は小文字に変換しない)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# sudo でも補完の対象
# zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin

## 補完候補をキャッシュする(apt-getやdpkgなど，対応したものに限り使える)
zstyle ':completion:*' use-cache true

setopt complete_in_word   # 語の途中でもカーソル位置で補完する。
setopt numeric_glob_sort  # 辞書順ではなく数字順に並べる。
setopt rm_star_wait       # rm * を確認する

# http://memo.officebrook.net/20100223.html
# alias元の補完を使用する。 unsetで正しい
unsetopt complete_aliases

# 追加の設定を読み込む
# `uname` を使う？
[ -f ${HOME}/.zshrc.mine ] && source ${HOME}/.zshrc.mine
[ -f ${HOME}/.zshrc.alias ] && source ${HOME}/.zshrc.alias
