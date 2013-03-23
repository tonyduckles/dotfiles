#
# Bash completion for fabric
# (https://gist.github.com/exhuma/2136677)
#
function _fab_complete() {
local cur
if [[ -f "fabfile.py" || -d "fabfile" ]]; then
    cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=( $(compgen -W "$(fab -F short -l)" -- ${cur}) )
    return 0
else
    # no fabfile.py found. Don't do anything.
    return 1
fi
}

complete -o nospace -F _fab_complete fab
