# various additional completions
# http://www.gnu.org/software/bash/manual/bashref.html#Programmable-Completion-Builtins

complete -F _known_hosts whois nslookup nmap
complete -F _known_hosts push_ssh_cert

complete -o nospace -A command killall
