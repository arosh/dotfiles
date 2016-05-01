#
# Language
#
if [[ -z "$LANG" ]]; then
  export LANG='ja_JP.UTF-8'
fi

#
# Paths
#
# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# http://qiita.com/mollifier/items/42ae46ff4140251290a7
path=(/usr/local/bin(N-/) $path)

if [[ "$HOST" = "h25is123.naist.jp" ]]; then
  # homebrewのインストール先
  path=(/private/var/netboot/Users/Shared/sho-ii/homebrew/bin(N-/) $path)
  # homebrew-caskのインストール先
  export HOMEBREW_CASK_OPTS="--caskroom=/Users/Shared/sho-ii/homebrew-cask"
fi

# http://qiita.com/yuku_t/items/c7ab1b1519825cc2c06f
export GOPATH=$HOME/.go
