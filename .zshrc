#
# Prezto
#
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

#
# Language
#
# https://fumiyas.github.io/2013/12/15/test.sh-advent-calendar.html
if [[ -z "$LANG" ]]; then
  export LANG="ja_JP.UTF-8"
fi

#
# Paths
#
# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# http://qiita.com/mollifier/items/42ae46ff4140251290a7
path=($HOME/bin(N-/) /usr/local/bin(N-/) /usr/sbin(N-/) /sbin(N-/) $path)

if [[ "$HOST" = "h25is123.naist.jp" ]]; then
  # homebrewのインストール先
  path=(/private/var/netboot/Users/Shared/sho-ii/homebrew/bin(N-/) $path)
  # homebrew-caskのインストール先
  export HOMEBREW_CASK_OPTS="--caskroom=/Users/Shared/sho-ii/homebrew-cask"
fi

# http://qiita.com/yuku_t/items/c7ab1b1519825cc2c06f
if [[ -z "$GOPATH" ]]; then
  export GOPATH="$HOME/.go"
fi

#
# modules/utility/init.zsh
#
# https://github.com/sorin-ionescu/prezto/issues/622
unsetopt CORRECT

# disable alias sl=ls
unalias sl

# disable alias rm='nocorrect rm -i'
unalias rm

#
# modules/history/init.zsh
#
HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"
HISTSIZE=100000 # 10000 is too small
SAVEHIST=100000

#
# modules/directory/init.zsh
#
setopt MULTIOS              # Write to multiple descriptors.
setopt EXTENDED_GLOB        # Use extended globbing syntax.

#
# User Settings
#
alias lla=la
alias rmdir="${aliases[rm]:-rm} -rf"

# --prefix=の後などでも補完を有効にする
setopt MAGIC_EQUAL_SUBST

# Ctrl-PとCtrl-Nで前方一致検索
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end

# Ctrl-^ で cd ..
# https://github.com/arael/configs/blob/master/zshrc.prezto#L140
function cdup() {
  echo
  cd ..
  prompt_${prompt_theme}_precmd
  zle reset-prompt
  return 0
}
zle -N cdup
bindkey '^\^' cdup

# Use `pbcopy` in modules/utility/init.zsh
clip() {
  cat $1 | pbcopy
}

#
# vcs_info
#
if [[ -s "${ZDOTDIR:-$HOME}/.zshrc.vcs_info" ]]; then
  source "${ZDOTDIR:-$HOME}/.zshrc.vcs_info"
fi

#
# zcoredump
#
# https://github.com/sorin-ionescu/prezto/blob/master/runcoms/zlogin
# Execute code that does not affect the current session in the background.
{
  # Compile the completion dump to increase startup speed.
  zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
  # if sizeof($zcompdump) > 0 and (sizeof(${zcompdump}.zwc) == 0 or $zcompdump is newer than ${zcompdump}.zwc)
  # http://zsh.sourceforge.net/Doc/Release/Conditional-Expressions.html
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    zcompile "$zcompdump"
  fi
} &!
