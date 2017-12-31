" autofolds
" =========
" Automatic folding based on custom section markers
" Inspired by: https://vi.stackexchange.com/a/6608

function! autofolds#foldexpr(lnum, ...)
  let s:filetype = a:0 > 0 ? a:1 : 'vim'  " optional 'filetype' param
  let s:comment_char = ''
  if s:filetype == 'vim'
    let s:comment_char = '"'
  elseif s:filetype == 'sh'
    let s:comment_char = '#'
  endif
  if s:comment_char == ''
    return '='
  endif
  let s:thisline = getline(a:lnum)
  let s:two_following_lines = 0
  if line(a:lnum) + 2 <= line('$')
    let s:line_1_after = getline(a:lnum+1)
    let s:line_2_after = getline(a:lnum+2)
    let s:two_following_lines = 1
  endif
  if !s:two_following_lines
      return '='
    endif
  else
    if (match(s:thisline, '^'.s:comment_char.' ----------') >= 0) &&
       \ (match(s:line_1_after, '^'.s:comment_char.' ') >= 0) &&
       \ (match(s:line_2_after, '^'.s:comment_char.' ----------') >= 0)
      return '>1'
    else
      return '='
    endif
  endif
endfunction

function! autofolds#foldtext()
  let s:lines = string(v:foldend-v:foldstart)  " # of lines in fold range
  let s:text = getline(v:foldstart+1)[2:]      " extract text after leading comment marker
  let s:text = substitute(s:text,'^\s*\(.\{-}\)\s*$', '\1', '')  " strip leading/trailing whitespace
  return '+'.repeat('-', 1 + v:foldlevel).repeat(' ', 3-len(s:lines)).s:lines.' lines: '.s:text.' '  " mimic standard foldtext() format
endfunction
