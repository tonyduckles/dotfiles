#	This is the default standard profile provided to a user.
#	They are expected to edit it to meet their own needs.
unalias cd
stty erase ^? intr ^C kill ^U echoe 
PATH=/epic/bin:/bin:/home/bin:/usr/bin:/bin:/opt/std/bin:/usr/local/bin:/usr/sbin
export PATH

set -a
PS1='$LOGNAME'@$(uname -n):'$PWD> '
set +a
PAGER=more

# Try to use tcsh or bash if available
if [[ -a /usr/local/bin/bash ]]
then
  SHELL="/usr/local/bin/bash"
  export SHELL; exec $SHELL
fi
if [[ -a /bin/bash ]]
then
  SHELL="/bin/bash"
  export SHELL; exec $SHELL
fi

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
