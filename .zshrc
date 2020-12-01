# differences between test, [, and [[
# https://fumiyas.github.io/2013/12/15/test.sh-advent-calendar.html
if [[ -z "${LANG}" ]]; then
  export LANG="ja_JP.UTF-8"
fi

# Ensure path arrays do not contain duplicates.
# http://zsh.sourceforge.net/Doc/Release/Shell-Builtin-Commands.html
typeset -gU path

# http://qiita.com/mollifier/items/42ae46ff4140251290a7
path=(${HOME}/bin(N-/) /usr/local/bin(N-/) $path)

if [[ -s "${HOME}/.zshrc.local" ]]; then
  source "${HOME}/.zshrc.local"
fi

# 1. On a WSL environment, a login shell cannot be changed from /bin/bash.
# 2. In a default setting of /bin/bash on WSL, `LS_COLORS` is configured.
# 3. Prezto load ${HOME}/.dir_colors only if `LS_COLORS` is not configured.
# Therefore, `LS_COLORS` should be cleared here to let Prezto to load `LS_COLORS`.
if [[ -s "${HOME}/.dir_colors" ]]; then
  export LS_COLORS=
fi

#
# Prezto
#
if [[ -s "${HOME}/.zprezto/init.zsh" ]]; then
  source "${HOME}/.zprezto/init.zsh"
fi

# Go
# Check if a program exists from a Zsh script
# http://stackoverflow.com/q/592620
# See .zprezto/modules/utility/init.zsh
if (( $+commands[go] )); then
  if [[ -z "$GOPATH" ]]; then
    # http://qiita.com/yuku_t/items/c7ab1b1519825cc2c06f
    export GOPATH="${HOME}/go"
  fi

  path=(${GOPATH}/bin(N-/) $path)
fi

# direnv
if (( $+commands[direnv] )); then
  eval "$(direnv hook zsh)"
fi

# Python

# for `pip install --user`
path=(${HOME}/.local/bin(N-/) $path)

if [[ -d "${HOME}/venv/default" ]]; then
  VIRTUAL_ENV_DISABLE_PROMPT=true source ${HOME}/venv/default/bin/activate
fi

# Ruby
if (( $+commands[rbenv] )); then
  eval "$(rbenv init -)"
fi

# Node
path=(${HOME}/.npm-packages/bin(N-/) $path)

# Kubectl
if (( $+commands[kubectl] )); then
  source <(kubectl completion zsh)
fi

# peco
# https://github.com/peco/peco/wiki/Sample-Usage#zsh-auto-complete-from-history-ctrlr
# https://gist.github.com/yuttie/2aeaecdba24256c73bf2
if (( $+commands[peco] )); then
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

# disable alias sl=ls
unalias sl

# disable alias l='ls -1A'
unalias l

# append indicator (one of */=>@|) to entries
# https://unix.stackexchange.com/a/82358
alias ls="${aliases[ls]:-ls} -F"

export EDITOR='vim'

if (( $+commands[vim] )); then
  alias view="${aliases[vim]:-vim} -R"
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
# Prezto use ~/.zhistory as history file, but use ~/.zsh_history for
# compatibility if it already exists.
if [[ -s "${HOME}/.zsh_history" ]]; then
  HISTFILE="${HOME}/.zsh_history"
fi
HISTSIZE=100000 # 10000 is too small
SAVEHIST=100000

#
# User Settings
#

# https://qiita.com/yuyuchu3333/items/b01536fa63d9f8fadf4f
function call_precmd() {
  if type precmd > /dev/null 2>&1; then
    precmd
  fi
  local precmd_func
  for precmd_func in ${precmd_functions}; do
    ${precmd_func}
  done
}

# Ctrl-^ で cd ..
# https://github.com/arael/configs/blob/master/zshrc.prezto#L140
function cdup() {
  echo
  cd ..
  call_precmd
  zle reset-prompt
  return 0
}
zle -N cdup
bindkey '^\^' cdup

# Use `pbcopy` in modules/utility/init.zsh
clip() {
  cat "$1" | pbcopy
}

# vcs_info
if [[ -s "${HOME}/.zshrc.vcs_info" ]]; then
  source "${HOME}/.zshrc.vcs_info"
fi
