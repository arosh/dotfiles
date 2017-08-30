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
