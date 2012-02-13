" Vim syntax file
" Language: Epic Release Script
" Maintainer: Tony Duckles
" Latest Revision: 10 Feb 2012

if exists("b:current_syntax")
  finish
endif

" comments
syntax match    scriptComment    "^REM.*$"

" script init commands
syntax keyword  scriptCommand    NAME SETAPP CHECKKEY
" script control
syntax keyword  scriptCommand    STOP
" additional script control
syntax keyword  scriptCommand    SETOSDIR SETMDIR SETJOBS
" log control
syntax keyword  scriptCommand    NEWLOG SETLOG LOG
" general install commands
syntax keyword  scriptCommand    EXEC CONVERT JOB QCHKSUM
" general install load commands
syntax keyword  scriptCommand    UNPACK LOADROU LOADGLO LOADETAN LOADSQL LOADTX LOADSRPT IMPORT
" general install compile commands
syntax keyword  scriptCommand    CMLIB CMROU CMLIBFN CMROUITM CMROUDICT CMSCR CMSCRITM CMREC CMMENU CMTABLE CMQUERY CMTX
" general install update commands
syntax keyword  scriptCommand    UPDATEINDEX UPDATECAT UPDATEGRP UPDATEITEMTAB
" general ETAN commands
syntax keyword  scriptCommand    BUILDETAN NEWETAN SETETAN
" general install save commands
syntax keyword  scriptCommand    SAVEGLO SAVEROU SAVESQL SAVETX
" general install delete commands
syntax keyword  scriptCommand    DELROU DELREC DELSCR DELITM DELTAB DELDICT DELMENU DELGLO DELSI DELCAT DELSRPT DELTX DELBF

syntax match    scriptParamNum   '^\d\+'  nextgroup=scriptParamDlm           skipwhite
syntax match    scriptParamDlm   '\~'     nextgroup=scriptParamVal contained skipwhite
syntax match    scriptParamVal   '.*'                              contained

hi def link scriptComment   Comment
hi def link scriptCommand   Type
hi def link scriptParamNum  PreProc
hi def link scriptParamDlm  Identifier
hi def link scriptParamVal  Statement

