" Set filetype=epicscript for matching *.TXT files

au! BufRead,BufNewFile *.TXT	if getline(1) =~ '^NAME\=' | setfiletype epicscript | endif
