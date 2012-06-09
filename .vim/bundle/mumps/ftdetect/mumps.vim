" ~/.vim/filetype.vim
" for working with GT.M or other MUMPS
" save this file as your ~/.vim/filetype.vim
" or if you have one already, insert these commands
" -- Jim Self <jaself@ucdavis.edu> June 2, 2001

"augroup filetypedetect

" MUMPS source files for GT.M
au! BufRead,BufNewFile *.m	setfiletype mumps

" saved MUMPS routine set from DTM
au! BufRead,BufNewFile *.rsa	setfiletype mumps
au! BufRead,BufNewFile *.RSA	setfiletype mumps

" saved MUMPS routine set from MSM, DSM, etc.
au! BufRead,BufNewFile *.rou	setfiletype mumps
au! BufRead,BufNewFile *.ROU	setfiletype mumps

" saved MUMPS routine set
au! BufRead,BufNewFile *.ro	setfiletype mumps

" Hypertext files with embedded m-tags - uses php syntax roughly
au! BufRead,BufNewFile *.ht	setfiletype php

"augroup END

" ~/.vim/scripts.vim
" for working with GT.M or other MUMPS
" save this file as your ~/.vim/scripts.vim
" or if you have one already, insert these commands
" -- Jim Self <jaself@ucdavis.edu> June 2, 2001

if did_filetype()       " filetype already set..
  finish                " ..don't do these checks
endif
if getline(1) =~ '^%\=\w\+\s\+;'  "first line - label and comment
  setfiletype mumps
elseif getline(1) =~ '^;'  "just a comment
  setfiletype mumps
endif

