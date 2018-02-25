#!/bin/bash
# ~/.bashrc: executed by bash(1) for non-login shells.
# A basically sane bash environment.

# ----------------------------------------------------------------------
#  BASICS
# ----------------------------------------------------------------------

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

# ----------------------------------------------------------------------
#  SHELL OPTIONS
# ----------------------------------------------------------------------

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

# ----------------------------------------------------------------------
# PATH
# ----------------------------------------------------------------------

# make sure $MANPATH has some sane defaults
: ${MANPATH="/usr/share/man"}
test -d "/usr/share/man" && MANPATH="/usr/share/man:$MANPATH"

# include the various sbin's along with /usr/local/bin
PATH="$PATH:/usr/local/sbin:/usr/sbin:/sbin"
PATH="/usr/local/bin:$PATH"

# use $HOME specific bin and sbin
test -d "$HOME/bin" && PATH="$HOME/bin:$PATH"
test -d "$HOME/sbin" && PATH="$HOME/sbin:$PATH"

# SmartOS pkgin
test -d "/opt/local" && PATH="/opt/local/sbin:/opt/local/bin:$PATH"
test -d "/opt/local/man" && MANPATH="/opt/local/man:$MANPATH"
# SmartOS local files
test -d "/opt/custom" && PATH="/opt/custom/sbin:/opt/custom/bin:$PATH"
test -d "/opt/custom/man" && MANPATH="/opt/custom/man:$MANPATH"
# SmartOS SDC
test -d "/smartdc" && PATH="/smartdc/bin:/opt/smartdc/bin:/opt/smartdc/agents/bin:$PATH"
test -d "/smartdc/man" && MANPATH="/smartdc/man:$MANPATH"
# SmartOS native binaries, for OS/LX zones
test -d "/native" && PATH="$PATH:/native/usr/sbin:/native/usr/bin:/native/sbin:/native/bin"
test -d "/native/usr/share/man" && MANPATH="$MANPATH:/native/usr/share/man"

# RVM
test -d "$HOME/.rvm/bin" && PATH="$PATH:$HOME/.rvm/bin"

# setup $GOPATH
test -d "/usr/local/share/golang" && export GOPATH=/usr/local/share/golang
test -n "$GOPATH" && PATH="$PATH:$GOPATH/bin"

# ----------------------------------------------------------------------
# ENVIRONMENT CONFIGURATION
# ----------------------------------------------------------------------

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

# ----------------------------------------------------------------------
# PAGER / EDITOR
# ----------------------------------------------------------------------

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

# ----------------------------------------------------------------------
# PROMPT
# ----------------------------------------------------------------------

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

# ----------------------------------------------------------------------
# MACOS X / DARWIN SPECIFIC
# ----------------------------------------------------------------------

if [ "$UNAME" = Darwin ]; then
    # put ports on the paths if /opt/local exists
    test -x /opt/local -a ! -L /opt/local && {
        PORTS=/opt/local

        # setup the PATH and MANPATH
        PATH="$PORTS/bin:$PORTS/sbin:$PATH"
        MANPATH="$PORTS/share/man:$MANPATH"

        # nice little port alias
        alias port="sudo nice -n +18 $PORTS/bin/port"
    }
    # put coreutils on the paths if /usr/local/opt/coreutils/libexec exists
    test -x /usr/local/opt/coreutils/libexec -a ! -L /usr/local/opt/coreutils/libexec && {
        # setup the PATH and MANPATH
        PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
        MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
    }
fi

# ----------------------------------------------------------------------
# SOLARIS SPECIFIC
# ----------------------------------------------------------------------

if [ "$UNAME" = SunOS ]; then
    # use GNU versions of core utils
    test -x /usr/gnu/bin/grep && alias grep="/usr/gnu/bin/grep"
    test -x /usr/gnu/bin/sed  && alias sed="/usr/gnu/bin/sed"
    test -x /usr/gnu/bin/awk  && alias awk="/usr/gnu/bin/awk"
fi

# ----------------------------------------------------------------------
# ALIASES / FUNCTIONS
# ----------------------------------------------------------------------

# 'ls' helpers
alias ll="ls -l"
alias l.="ls -d .*"
alias ll.="ls -ld .*"
alias lla="ls -la"

# use 'git diff --no-index' as a prettier 'diff' alternative (if available)
test -n "$(type -P git)" && alias diff="git diff --no-index"

# alias 'vi' to 'vim' if Vim is installed
vim="$(type -P vim)"
test -n "$vim" && {
    alias vi='vim'
}
unset vim

# disk usage with human sizes and minimal depth
alias du1='du -h --max-depth=1'
alias fn='find . -name'
alias hi='history | tail -20'

# alias csh-style "rebash" to bash equivalent
alias rehash="hash -r"

# set 'screen' window title
settitle_screen() {
    printf "\033k%s\033\\" "$@"
}
# set 'xterm' window title
settitle_window() {
    printf "\033]0;%s\007" "$@"
}

# svn-wrapper
alias svn=svn-wrapper

# ----------------------------------------------------------------------
# BASH COMPLETION
# ----------------------------------------------------------------------

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

# ----------------------------------------------------------------------
# LS AND DIRCOLORS
# ----------------------------------------------------------------------

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

# --------------------------------------------------------------------
# MISC COMMANDS
# --------------------------------------------------------------------

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

# --------------------------------------------------------------------
# PATH MANIPULATION FUNCTIONS
# --------------------------------------------------------------------

# Usage: pls [<var>]
# List path entries of PATH or environment variable <var>.
pls () { eval echo \$${1:-PATH} |tr : '\n'; }

# Usage: pshift [-n <num>] [<var>]
# Shift <num> entries off the front of PATH or environment var <var>.
# with the <var> option. Useful: pshift $(pwd)
pshift () {
    local n=1
    [ "$1" = "-n" ] && { n=$(( $2 + 1 )); shift 2; }
    eval "${1:-PATH}='$(pls |tail -n +$n |tr '\n' :)'"
}

# Usage: ppop [-n <num>] [<var>]
# Pop <num> entries off the end of PATH or environment variable <var>.
ppop () {
    local n=1 i=0
    [ "$1" = "-n" ] && { n=$2; shift 2; }
    while [ $i -lt $n ]
    do eval "${1:-PATH}='\${${1:-PATH}%:*}'"
       i=$(( i + 1 ))
    done
}

# Usage: prm <path> [<var>]
# Remove <path> from PATH or environment variable <var>.
prm () { eval "${2:-PATH}='$(pls $2 |grep -v "^$1\$" |tr '\n' :)'"; }

# Usage: punshift <path> [<var>]
# Shift <path> onto the beginning of PATH or environment variable <var>.
punshift () { eval "${2:-PATH}='$1:$(eval echo \$${2:-PATH})'"; }

# Usage: ppush <path> [<var>]
ppush () { eval "${2:-PATH}='$(eval echo \$${2:-PATH})':$1"; }

# Usage: puniq [<path>]
# Remove duplicate entries from a PATH style value while retaining
# the original order. Use PATH if no <path> is given.
#
# Example:
#   $ puniq /usr/bin:/usr/local/bin:/usr/bin
#   /usr/bin:/usr/local/bin
puniq () {
    echo "$1" | tr : '\n' | nl | sort -u -k 2,2 | sort -n |
    cut -f 2- | tr '\n' : | sed -e 's/:$//' -e 's/^://'
}

# -------------------------------------------------------------------
# USER SHELL ENVIRONMENT
# -------------------------------------------------------------------

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

# -------------------------------------------------------------------
# MOTD / FORTUNE
# -------------------------------------------------------------------

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
# vim: foldmethod=expr foldexpr=autofolds#foldexpr(v\:lnum,'sh') foldtext=autofolds#foldtext() foldlevel=2
