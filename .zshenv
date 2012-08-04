## Environment variable configuration
##
# LANG
#
export LANG=ja_JP.UTF-8
case ${UID} in
0)
    LANG=C
    ;;
esac

[ -f ${HOME}/.zshenv.osx ] && source ${HOME}/.zshenv.osx
