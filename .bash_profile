# ~/.bash_profile: executed by bash(1) for login shells.

umask 022
if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi

# keychain
if [ -f ~/.ssh/id_dsa ]; then
  /usr/bin/keychain -q ~/.ssh/id_dsa
  source ~/.keychain/`hostname`-sh > /dev/null
fi
