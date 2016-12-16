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

# http://d.hatena.ne.jp/yascentur/20111111/1321015289
export CPATH
[ -z "$cpath" ] && typeset -T CPATH cpath
export LD_LIBRARY_PATH
[ -z "$ld_library_path" ] && typeset -T LD_LIBRARY_PATH ld_library_path
export LIBRARY_PATH
[ -z "$library_path" ] && typeset -T LIBRARY_PATH library_path
export MODULEPATH
[ -z "$modulepath" ] && typeset -T MODULEPATH modulepath

# Ensure path arrays do not contain duplicates.
# http://zsh.sourceforge.net/Doc/Release/Shell-Builtin-Commands.html
typeset -gU path fpath manpath cpath ld_library_path library_path modulepath

# http://qiita.com/mollifier/items/42ae46ff4140251290a7
path=($HOME/bin(N-/) /usr/local/bin(N-/) /usr/sbin(N-/) /sbin(N-/) $path)

if [[ "$HOST" = "h25is123.naist.jp" ]]; then
  source "${ZDOTDIR:-$HOME}/.zshrc.h25is123"
fi

if [[ -d "/opt/homebrew-cask/Caskroom" ]]; then
  export HOMEBREW_CASK_OPTS="--caskroom=/opt/homebrew-cask/Caskroom"
fi

#
# Prezto
#
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Check if a program exists from a Zsh script
# http://stackoverflow.com/q/592620
# See .zprezto/modules/utility/init.zsh
if (( $+commands[brew] )); then
  # MANPATH
  # http://qiita.com/mollifier/items/2dc274244ac698bb943b
  # https://linuxjm.osdn.jp/html/man-db/man1/manpath.1.html
  if [[ -z "$MANPATH" ]]; then
    export MANPATH=`manpath`
  fi
  manpath=(`brew --prefix`/share/man(N-/) $manpath)

  # brew info z
  # https://github.com/rupa/z
  if [[ -s "`brew --prefix`/etc/profile.d/z.sh" ]]; then
    source "`brew --prefix`/etc/profile.d/z.sh"
  fi
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

#
# brew info pyenv
#
if (( $+commands[pyenv] )); then
  eval "$(pyenv init -)"
fi

#
# brew cask info google-cloud-sdk
#
if [[ -d "/opt/homebrew-cask/Caskroom/google-cloud-sdk/latest/google-cloud-sdk" ]]; then
  source "/opt/homebrew-cask/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
  source "/opt/homebrew-cask/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
fi

#
# Modules
#
# moduleはコマンドではなくシェル関数なので $+commands[module] は使えない
# http://stackoverflow.com/questions/592620/check-if-a-program-exists-from-a-bash-script
if command -v module >/dev/null 2>&1; then
  # http://d.hatena.ne.jp/earth2001y/20130205/modules
  modulepath=($HOME/.modulefiles(N-/) $modulepath)
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

# http://qiita.com/delphinus/items/b04752bb5b64e6cc4ea9
# -i: ignorecase smartcase
# -M: verbose prompt
# -R: ANSI color escape sequences will be displayed
export LESS='-i -M -R'

# diff-highlight
# http://qiita.com/takyam/items/d6afacc7934de9b0e85e
# if (( $+commands[git] )); then
#   path=($(dirname `which git`)/$(dirname $(readlink `which git`))/../share/git-core/contrib/diff-highlight(N-/) $path)
# fi

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
