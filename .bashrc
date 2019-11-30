#!/bin/bash
# ~/.bashrc: executed by bash(1) for non-login shells.
# A basically sane bash environment.
# Resources:
# - https://github.com/rtomayko/dotfiles/blob/rtomayko/.bashrc

# ---------------------------------------------------------------------------
#  BASICS
# ---------------------------------------------------------------------------

# short-circuit for non-interactive sessions
[ -z "$PS1" ] && return

# the basics
: ${HOME=~}
: ${LOGNAME=$(id -un)}
: ${UNAME=$(uname)}
# strip OS type and version under Cygwin (e.g. CYGWIN_NT-5.1 => Cygwin)
UNAME=${UNAME/CYGWIN_*/Cygwin}

# complete hostnames from this file
HOSTFILE=~/.ssh/known_hosts

# readline config
INPUTRC=~/.inputrc

# if current $TERM isn't valid, fall-back to TERM=xterm-color or TERM=xterm
case $(tput colors 2>&1) in
    tput* )
        export TERM=xterm-color
        case $(tput colors 2>&1) in
            tput* )
                export TERM=xterm
                ;;
        esac
        ;;
esac

# ---------------------------------------------------------------------------
#  SHELL OPTIONS
# ---------------------------------------------------------------------------

# notify of bg job completion immediately
set -o notify

# shell opts. see bash(1) for details
shopt -s cdspell >/dev/null 2>&1
shopt -s checkjobs >/dev/null 2>&1
shopt -s checkwinsize >/dev/null 2>&1
shopt -s extglob >/dev/null 2>&1
shopt -s histappend >/dev/null 2>&1
shopt -s hostcomplete >/dev/null 2>&1
shopt -s interactive_comments >/dev/null 2>&1
shopt -u mailwarn >/dev/null 2>&1
shopt -s no_empty_cmd_completion >/dev/null 2>&1

# don't check for new mail
unset MAILCHECK

# disable core dumps
ulimit -S -c 0

# default umask
umask 0022

# ---------------------------------------------------------------------------
# PATH
# ---------------------------------------------------------------------------

# make sure $MANPATH has some sane defaults
MANPATH="/usr/share/man:/usr/local/share/man:$MANPATH"

# include the various sbin's along with /usr/local/bin
PATH="$PATH:/usr/local/sbin:/usr/sbin:/sbin"
PATH="/usr/local/bin:$PATH"

# use $HOME specific bin and sbin
path_start="$path_start:$HOME/bin"
test -d "$HOME/sbin" && path_start="$path_start:$HOME/sbin"

# macOS homebrew: include non-prefixed coreutils
if [ -d "/usr/local/opt/coreutils/libexec" ]; then
    path_start="$path_start:/usr/local/opt/coreutils/libexec/gnubin"
    manpath_start="$manpath_start:/usr/local/opt/coreutils/libexec/gnuman"
fi

# SmartOS: local pkgin binaries
if [ -d "/opt/local" ]; then
    path_start="$path_start:/opt/local/sbin:/opt/local/bin"
    manpath_start="$manpath_start:/opt/local/man"
fi
# SmartOS: local custom scripts
if [ -d "/opt/custom" ]; then
    path_start="$path_start:/opt/custom/sbin:/opt/custom/bin"
    manpath_start="$manpath_start:/opt/custom/man"
fi
# SmartOS: SDC
if [ -d "/smartdc" ]; then
    path_start="$path_start:/smartdc/bin:/opt/smartdc/bin:/opt/smartdc/agents/bin"
    manpath_start="$manpath_start:/smartdc/man"
fi
# SmartOS: native binaries, for OS/LX zones
if [ -d "/native" ]; then
    path_end="$path_end:/native/usr/sbin:/native/usr/bin:/native/sbin:/native/bin"
    manpath_end="$manpath_end:/native/usr/share/man"
fi

# python pip --user
for python in "python" "python2" "python3"; do
    if [ -n "$(type -P $python)" ]; then
        pybin="$($python -m site --user-base)/bin"
        test -d "$pybin" && path_end="$path_end:$pybin"
    fi
done
unset python pybin

PATH="$path_start:$PATH:$path_end"
MANPATH="$manpath_start:$MANPATH:$manpath_end"
unset path_start path_end manpath_start manpath_end

# ---------------------------------------------------------------------------
# ENVIRONMENT CONFIGURATION
# ---------------------------------------------------------------------------

# detect interactive shell
case "$-" in
    *i*) INTERACTIVE=yes ;;
    *)   unset INTERACTIVE ;;
esac

# detect login shell
case "$0" in
   -*) LOGIN=yes ;;
   *)  unset LOGIN ;;
esac

# enable en_US locale w/ utf-8 encodings if not already
# configured
: ${LANG:="en_US.UTF-8"}
: ${LANGUAGE:="en"}
: ${LC_CTYPE:="en_US.UTF-8"}
: ${LC_ALL:="en_US.UTF-8"}
export LANG LANGUAGE LC_CTYPE LC_ALL

# ignore backups, CVS directories, python bytecode, vim swap files
FIGNORE="~:CVS:#:.pyc:.swp:.swa:apache-solr-*"

# history stuff
HISTCONTROL=ignoreboth
HISTFILESIZE=10000
HISTSIZE=10000

# ---------------------------------------------------------------------------
# PAGER / EDITOR
# ---------------------------------------------------------------------------

# see what we have to work with ...
HAVE_VIM=$(command -v vim)

# EDITOR
test -n "$HAVE_VIM" &&
    EDITOR=vim ||
    EDITOR=vi
export EDITOR

# PAGER
if test -n "$(command -v less)" ; then
    PAGER="less"
    MANPAGER="less"
    LESS="-FiRX"
    export LESS
else
    PAGER=more
    MANPAGER="$PAGER"
fi
export PAGER MANPAGER

# ---------------------------------------------------------------------------
# PROMPT
# ---------------------------------------------------------------------------

# http://en.wikipedia.org/wiki/ANSI_escape_code#graphics

if [ "$UID" = 0 ]; then
    # root
    PS_C1="\[\033[1;31m\]"  # red
    PS_C2="\[\033[0;37m\]"  # grey
    PS_P="#"
else
    case "$UNAME" in
        Cygwin)
            PS_C1="\[\033[0;32m\]"  # green
            PS_C2="\[\033[0;37m\]"  # grey
            ;;
        Darwin)
            PS_C1="\[\033[1;97m\]"  # white
            PS_C2="\[\033[0;37m\]"  # grey
            ;;
        SunOS)
            PS_C1="\[\033[1;96m\]"  # cyan
            PS_C2="\[\033[0;36m\]"  # cyan
            ;;
        *)
            PS_C1="\[\033[1;93m\]"  # yellow
            PS_C2="\[\033[0;33m\]"  # brown
    esac
    PS_P="\$"
fi

prompt_simple() {
    unset PROMPT_COMMAND
    PS1="[\u@\h:\w]\$ "
    PS2="> "
}

prompt_compact() {
    unset PROMPT_COMMAND
    PS1="${PS_C1}${PS_P}\[\033[0m\] "
    PS2="> "
}

prompt_color() {
    # if git and the git bash_completion scripts are installed, use __git_ps1() to show current branch info.
    # never show branch info for $HOME (dotfiles) repo.
    # use the following to exclude a given repo: `git config --local --bool --add bash.hidePrompt true`
    if [ -n "$(type -P git)" -a "$(type -t __git_ps1)" = "function" ]; then
        PS_GIT='$(test -n "$(__git_ps1 %s)" &&
                  test "$(git rev-parse --show-toplevel)" != "$HOME" &&
                  test "$(git config --bool bash.hidePrompt)" != "true" &&
                  __git_ps1 "{\[\033[0;40;36m\]%s\[\033[0;90m\]}")'
        export GIT_PS1_SHOWDIRTYSTATE=1
    fi
    PS1="\[\033[0;90m\][${PS_C1}\u@\h\[\033[0m\]\[\033[0;90m\]:${PS_C2}\w\[\033[0;90m\]]${PS_GIT}${PS_P}\[\033[0m\] "
    PS2="> "
}

# ---------------------------------------------------------------------------
# ALIASES
# ---------------------------------------------------------------------------

# 'ls' helpers
alias ll="ls -l"
alias l.="ls -d .*"
alias ll.="ls -ld .*"
alias lla="ls -la"

# use 'git diff --no-index' as a prettier 'diff' alternative (if available)
test -n "$(type -P git)" && alias diff="git diff --no-index"

# alias 'vi' to 'vim' if Vim is installed
test -n "$(type -P vim)" && alias vi='vim'

# alias csh-style "rebash" to bash equivalent
alias rehash="hash -r"

# svn-wrapper
alias svn=svn-wrapper

if [ "$UNAME" = SunOS ]; then
    # Solaris: use GNU versions of coreutils
    test -x /usr/gnu/bin/grep && alias grep="/usr/gnu/bin/grep"
    test -x /usr/gnu/bin/sed  && alias sed="/usr/gnu/bin/sed"
    test -x /usr/gnu/bin/awk  && alias awk="/usr/gnu/bin/awk"
fi

# ---------------------------------------------------------------------------
# BASH COMPLETION
# ---------------------------------------------------------------------------

test -z "$BASH_COMPLETION" && {
    bash=${BASH_VERSION%.*}; bmajor=${bash%.*}; bminor=${bash#*.}
    test -n "$PS1" && test $bmajor -gt 1 && {
        # search for a bash_completion file to source
        for f in /usr/local/etc/bash_completion \
                 /usr/pkg/etc/bash_completion \
                 /opt/local/etc/bash_completion \
                 /etc/bash_completion \
                 /etc/bash/bash_completion
        do
            test -f $f && {
                . $f
                break
            }
        done
    }
    unset bash bmajor bminor
}

# restore some key environment variables which may have been unset
# by bash_completion script
: ${HOME=~}
: ${LOGNAME=$(id -un)}
: ${UNAME=$(uname)}

# override and disable tilde expansion
_expand() {
    return 0
}

# ---------------------------------------------------------------------------
# LS AND DIRCOLORS
# ---------------------------------------------------------------------------

# we always pass these to ls(1)
LS_COMMON="-p"

# if the dircolors utility is available, set that up for ls
dircolors="$(type -P gdircolors dircolors | head -1)"
test -n "$dircolors" && {
    COLORS=/etc/DIR_COLORS
    test -e "/etc/DIR_COLORS.$TERM"   && COLORS="/etc/DIR_COLORS.$TERM"
    test -e "$HOME/.dircolors"        && COLORS="$HOME/.dircolors"
    test ! -e "$COLORS"               && COLORS=
    eval `$dircolors --sh $COLORS`
}
unset dircolors

# enable color ls output if available
test -n "$COLORS" &&
    LS_COMMON="--color=auto $LS_COMMON"

# setup the main ls alias if we've established common args
test -n "$LS_COMMON" &&
    alias ls="command ls $LS_COMMON"

# setup color grep output if available
if [ -n "$COLORS" ]; then
    case "$UNAME" in
        "SunOS")
            test -x /usr/gnu/bin/grep && alias grep="/usr/gnu/bin/grep --color=always"
            test -x /opt/local/bin/grep && alias grep="/opt/local/bin/grep --color=always"
            ;;
        *)
            alias grep="command grep --color=always"
            ;;
    esac
    # older versions of grep only support a singular highlight color
    export GREP_COLOR='1;32'
    # newer versions of grep have more flexible color configuration
    export GREP_COLORS='fn=36:ln=33:ms=1;32'
fi

# ---------------------------------------------------------------------------
# MISC FUNCTIONS
# ---------------------------------------------------------------------------

# set 'screen' window title
settitle_screen() {
    printf "\033k%s\033\\" "$@"
}
# set 'xterm' window title
settitle_window() {
    printf "\033]0;%s\007" "$@"
}

# push SSH public key to another box
push_ssh_cert() {
    local _host
    test -f ~/.ssh/id_rsa.pub || ssh-keygen -t rsa -b 4096
    for _host in "$@";
    do
        echo $_host
        ssh $_host 'cat >> ~/.ssh/authorized_keys' < ~/.ssh/id_rsa.pub
    done
}

# ---------------------------------------------------------------------------
# PATH MANIPULATION FUNCTIONS
# ---------------------------------------------------------------------------

# Usage: pls [<var>]
# List path entries of PATH or environment variable <var>.
pls () { eval echo \$${1:-PATH} | tr ':' '\n'; }

# Usage: ppop [-n <num>] [<var>]
# Pop <num> entries off the end of PATH or environment variable <var>.
ppop () {
    local n=1
    [ "$1" = "-n" ] && { n=$2; shift 2; }
    local i=0 var=${1:-PATH}
    local list=$(eval echo \$$var)
    while [ $i -lt $n ]; do
        list=${list%:*}
        i=$(( i + 1 ))
    done
    eval "$var='$list'"
}

# Usage: ppush <path> [<var>]
# Push an entry onto the end of PATH or enviroment variable <var>.
ppush () {
    local var=${2:-PATH}
    local list=$(eval echo \$$var)
    local i=0 dir=""
    IFS=':' read -a dirs <<< "$1"
    for ((i=0; i<${#dirs[@]}; i++)); do
        dir=$(eval echo "${dirs[$i]}")
        [ ! -d "$dir" ] && continue
        [ -n "$list" ] && list="$list:$dir" || list="$dir"
    done
    eval "$var='$list'"
}

# Usage: pinsert <path> [<var>]
# Push an entry onto the start of PATH or enviroment variable <var>.
pinsert () {
    local var=${2:-PATH}
    local list=$(eval echo \$$var)
    local i=0 dir=""
    IFS=':' read -a dirs <<< "${1}"
    for ((i=${#dirs[@]}-1; i>=0; i--)); do
        dir=$(eval echo "${dirs[$i]}")
        [ ! -d "$dir" ] && continue
        [ -n "$list" ] && list="$dir:$list" || list="$dir"
    done
    eval "$var='$list'"
}

# Usage: prm <path> [<var>]
# Remove <path> from PATH or environment variable <var>.
prm () { eval "${2:-PATH}='$(pls $2 | grep -v "^$1\$" | tr '\n' ':')'"; }

# Usage: puniq [<pathlist>]
# Remove duplicate entries from a PATH style value while retaining
# the original order. Use PATH if no <path> is given.
#
# Example:
#   $ puniq /usr/bin:/usr/local/bin:/usr/bin
#   /usr/bin:/usr/local/bin
puniq () { echo "$1" | tr ':' '\n' | grep -v "^$" | nl | sort -u -k 2,2 | sort -n | cut -f 2- | paste -s -d ':' -; }

# ---------------------------------------------------------------------------
# USER SHELL ENVIRONMENT
# ---------------------------------------------------------------------------

# source ~/.shenv now if it exists
test -r ~/.shenv &&
    . ~/.shenv

# condense PATH entries
PATH=$(puniq "$PATH")
MANPATH=$(puniq "$MANPATH")

# use the color prompt by default when interactive
test -n "$PS1" &&
    prompt_color

# fzf
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules,*.swp,.venv}/*" 2> /dev/null'
export FZF_DEFAULT_OPTS='--bind J:down,K:up --reverse --ansi --multi'

# ---------------------------------------------------------------------------
# MOTD / FORTUNE
# ---------------------------------------------------------------------------

test -n "$INTERACTIVE" -a -n "$LOGIN" && {
    # get current uname and uptime (if exists on this host)
    # strip any leading whitespace from uname and uptime commands
    t_uname="$(test -n "`type -P uname`" && uname -npsr | sed -e 's/^\s+//')"
    t_uptime="$(test -n "`type -P uptime`" && uptime | sed -e 's/^\s+//')"
    if [ -n "$t_uname" ] || [ -n "$t_uptime" ]; then
        echo " --"
        test -n "$t_uname" && echo $t_uname
        test -n "$t_uptime" && echo $t_uptime
        echo " --"
    fi
    unset t_uname t_uptime
}

# vim: ts=4 sts=4 shiftwidth=4 expandtab
