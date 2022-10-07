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
keychain=$(type -P keychain)
test -n "$keychain" && \
  test -z "$SUDO_USER" && {
  ids=""
  test -f ~/.ssh/id_rsa && ids="$ids id_rsa"
  test -f ~/.ssh/id_ed25519 && ids="$ids id_ed25519"
  if [ -n "$ids" ]; then
    eval `$keychain -q $ids`
    source ~/.keychain/`hostname`-sh > /dev/null
  fi
  unset ids
}
unset keychain
