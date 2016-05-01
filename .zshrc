# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

### modules/utility/init.zsh ###

# https://github.com/sorin-ionescu/prezto/issues/622
unsetopt CORRECT

# disable alias sl=ls
unalias sl

# disable alias rm='nocorrect rm -i'
unalias rm

### modules/history/init.zsh ###
HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"
HISTSIZE=100000 # 10000 is too small
SAVEHIST=100000

### modules/directory/init.zsh ###
setopt MULTIOS              # Write to multiple descriptors.
setopt EXTENDED_GLOB        # Use extended globbing syntax.

### User Settings ###
alias lla=la
alias rmdir="${aliases[rm]:-rm} -rf"

# --prefix=の後などでも補完を有効にする
setopt MAGIC_EQUAL_SUBST

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

if [[ -s "${ZDOTDIR:-$HOME}/.zshrc.vcs_info" ]]; then
  source "${ZDOTDIR:-$HOME}/.zshrc.vcs_info"
fi
