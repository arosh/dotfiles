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
# http://zsh.sourceforge.net/Doc/Release/Shell-Builtin-Commands.html
typeset -gU cdpath fpath mailpath path

# http://qiita.com/mollifier/items/42ae46ff4140251290a7
path=($HOME/bin(N-/) /usr/local/bin(N-/) /usr/sbin(N-/) /sbin(N-/) $path)

if [[ "$HOST" = "h25is123.naist.jp" ]]; then
  # homebrewのインストール先
  LOCAL=/private/var/netboot/Users/Shared/sho-ii
  path=(${LOCAL}/homebrew/bin(N-/) $path)

  # homebrewが使用するtmp (`brew --prefix`と同一の物理ドライブを指定する)
  export HOMEBREW_TEMP="${LOCAL}/tmp"
  # homebrew-caskのインストール先
  export HOMEBREW_CASK_OPTS="--caskroom=${LOCAL}/homebrew-cask --appdir=${HOME}/Applications --binarydir=${HOME}/bin"
fi

#
# MacTeX
#
path=(/Library/TeX/texbin(N-/) $path)

#
# Go
#
if (( $+commands[go] )); then
  if [[ -z "$GOPATH" ]]; then
    # http://qiita.com/yuku_t/items/c7ab1b1519825cc2c06f
    export GOPATH="$HOME/.go"
  fi

  path=($GOPATH/bin(N-/) $path)
fi

# Check if a program exists from a Zsh script
# http://stackoverflow.com/q/592620
# See .zprezto/modules/utility/init.zsh
if (( $+commands[brew] )); then
  # MANPATH
  # http://qiita.com/mollifier/items/2dc274244ac698bb943b
  if [[ -z "$MANPATH" ]]; then
    export MANPATH=:
  fi
  manpath=(`brew --prefix`/share/man(N-/) $manpath)

  # brew info z
  # https://github.com/rupa/z
  if [[ -s "`brew --prefix`/etc/profile.d/z.sh" ]]; then
    source "`brew --prefix`/etc/profile.d/z.sh"
  fi

  # brew info byobu
  if (( $+commands[byobu] )); then
    export BYOBU_PREFIX=$(brew --prefix)
  fi
fi

#
# Modules
#
if [[ -z "$modulepath" ]]; then
  # http://d.hatena.ne.jp/yascentur/20111111/1321015289
  typeset -T MODULEPATH modulepath
  modulepath=($HOME/.modulefiles(N-/) $modulepath)
fi

#
# Prezto
#
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
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

# disable alias l='ls -1A'
alias l='ll'

alias lla='la'
alias rmdir="${aliases[rm]:-rm} -rf"

if (( $+commands[vim] )); then
  alias view='${aliases[vim]:-vim} -R'
fi

# diff-highlight
# http://qiita.com/takyam/items/d6afacc7934de9b0e85e
if (( $+commands[git] )); then
  # path=($(dirname `which git`)/$(dirname $(readlink `which git`))/../share/git-core/contrib/diff-highlight(N-/) $path)
fi

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
