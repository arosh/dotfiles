#
# Language
#
# 『test と [ と [[ コマンドの違い』
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

if [[ "$OSTYPE" = "linux-gnu" ]]; then
  path=($HOME/.linuxbrew/bin(N-/) $path)
  # ld_library_path=($HOME/.linuxbrew/lib(N-/) $ld_library_path)
fi

if [[ -s "${ZDOTDIR:-$HOME}/.zshrc.local" ]]; then
  source "${ZDOTDIR:-$HOME}/.zshrc.local"
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

  # diff-highlight
  # http://qiita.com/takyam/items/d6afacc7934de9b0e85e
  path=(`brew --prefix`/share/git-core/contrib/diff-highlight(N-/) $path)
fi

# MacTeX
path=(/Library/TeX/texbin(N-/) $path)

# Go
if (( $+commands[go] )); then
  if [[ -z "$GOPATH" ]]; then
    # http://qiita.com/yuku_t/items/c7ab1b1519825cc2c06f
    export GOPATH="$HOME/go"
  fi

  path=($GOPATH/bin(N-/) $path)
fi

# diff-highlight
path=(/usr/share/doc/git/contrib/diff-highlight(N-/) $path)

# direnv
if (( $+commands[direnv] )); then
  eval "$(direnv hook zsh)"
fi

# Python
if [[ -d "$HOME/.virtualenvs/default" ]]; then
  VIRTUAL_ENV_DISABLE_PROMPT=true source $HOME/.virtualenvs/default/bin/activate
fi

pip-upgrade() {
  pip list --outdated --format=legacy | awk '{print $1}' | xargs pip install -U
}

# Ruby
if (( $+commands[rbenv] )); then
  eval "$(rbenv init -)"
fi

# android-sdk
if [[ -d "/usr/local/share/android-sdk" ]]; then
  export ANDROID_HOME=/usr/local/share/android-sdk
fi

# google-cloud-sdk
# if [[ -d "/opt/homebrew-cask/Caskroom/google-cloud-sdk/latest/google-cloud-sdk" ]]; then
#   source "/opt/homebrew-cask/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
#   source "/opt/homebrew-cask/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
# fi

# peco
# https://github.com/peco/peco/wiki/Sample-Usage#zsh-auto-complete-from-history-ctrlr
# https://gist.github.com/yuttie/2aeaecdba24256c73bf2
if which peco &> /dev/null; then
  function peco_select_history() {
    local tac
    { which gtac &> /dev/null && tac="gtac" } || \
      { which tac &> /dev/null && tac="tac" } || \
      tac="tail -r"
    BUFFER=$(fc -l -n 1 | eval $tac | \
                peco --layout=bottom-up --query "$LBUFFER")
    CURSOR=$#BUFFER # move cursor
    zle -R -c       # refresh
  }

  zle -N peco_select_history
  bindkey '^r' peco_select_history
fi

# Fasd
alias z='fasd_cd -d' # cd, same functionality as j in autojump

#
# modules/utility/init.zsh
#
# https://github.com/sorin-ionescu/prezto/issues/622
unsetopt CORRECT

# disable alias sl=ls
unalias sl

# disable alias l='ls -1A'
unalias l

# disable alias rm='rm -i'
unalias rm

alias rmdir="${aliases[rm]:-rm} -rf"

export EDITOR='vim'

# if (( $+commands[nvim] )); then
#   alias vim='${aliases[nvim]:-nvim}'
# fi

if (( $+commands[vim] )); then
  alias view='${aliases[vim]:-vim} -R'
fi

# http://qiita.com/delphinus/items/b04752bb5b64e6cc4ea9
# -g: hlsearch
# -i: ignorecase smartcase
# -M: verbose prompt
# -R: ANSI color escape sequences will be displayed
export LESS='-g -i -M -R'

#
# modules/history/init.zsh
#
HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"
HISTSIZE=100000 # 10000 is too small
SAVEHIST=100000

#
# modules/directory/init.zsh
#
setopt MULTIOS       # Write to multiple descriptors.
setopt EXTENDED_GLOB # Use extended globbing syntax.

#
# User Settings
#

# Ctrl-PとCtrl-Nで前方一致検索
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end

# https://qiita.com/yuyuchu3333/items/b01536fa63d9f8fadf4f
function call_hook_precmd() {
  if type precmd > /dev/null 2>&1; then
    precmd
  fi
  local precmd_func
  for precmd_func in $precmd_functions; do
    $precmd_func
  done
}

# Ctrl-^ で cd ..
# https://github.com/arael/configs/blob/master/zshrc.prezto#L140
function cdup() {
  echo
  cd ..
  call_hook_precmd
  zle reset-prompt
  return 0
}
zle -N cdup
bindkey '^\^' cdup

# Use `pbcopy` in modules/utility/init.zsh
clip() {
  cat $1 | pbcopy
}

# vcs_info
if [[ -s "${ZDOTDIR:-$HOME}/.zshrc.vcs_info" ]]; then
  source "${ZDOTDIR:-$HOME}/.zshrc.vcs_info"
fi
