# ~/.bash_profile: executed by bash(1) for login shells.

umask 022
if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi

# Set mintty color-palette
if [ "$UNAME" = "Cygwin" ]; then
  source ~/.mintty/colors/solarized-ansi.sh
fi

# keychain
keychain="$(type -P keychain)"
test -n "$keychain" && {
  if [ -f ~/.ssh/id_rsa ]; then
    eval `$keychain -q ~/.ssh/id_rsa`
    source ~/.keychain/`hostname`-sh > /dev/null
  fi
}
unset keychain

# kerberos
kinit="$(type -P kinit)"
test -n "$kinit" && {
    KRB5_CONFIG="$HOME/.krb5.conf"
    export KRB5_CONFIG
}
unset kinit

# Load RVM function
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
