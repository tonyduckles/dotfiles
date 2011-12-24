# ~/.bash_profile: executed by bash(1) for login shells.

umask 022
if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi

# Change ANSI colors to Solarized-style colors
if [ "$UNAME" = "Cygwin" ]; then
  if [ -f ~/.term_colorpalette ]; then
    source ~/.term_colorpalette
  fi
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

# Load RVM function
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
