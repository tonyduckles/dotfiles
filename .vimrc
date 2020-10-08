" ---------------------------------------------------------------------------
" General
" ---------------------------------------------------------------------------

set nocompatible                      " essential
set history=1000                      " lots of command line history
set confirm                           " error files / jumping
set fileformats=unix,dos,mac          " support these files
set iskeyword+=_,$,@,%,#,-            " none word dividers
set viminfo='1000,f1,:100,@100,/20
set modeline                          " make sure modeline support is enabled
set autoread                          " reload files (no local changes only)

" ---------------------------------------------------------------------------
"  Plugins
" ---------------------------------------------------------------------------

call plug#begin('~/.vim/plugged')

" Colors
Plug 'tonyduckles/vim-colorschemes'

" Interface
Plug 'airblade/vim-gitgutter'         " shows git diff in the gutter
Plug 'farmergreg/vim-lastplace'       " intelligently reopen files at your last edit position
Plug 'godlygeek/csapprox'             " make gui-only colorschemes work automagically in terminal vim
Plug 'junegunn/goyo.vim'              " distraction-free writing
Plug 'junegunn/limelight.vim'         " hyperfocus-writing
Plug 'kien/ctrlp.vim'                 " fuzzy file, buffer, mru, etc finder
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }  " file system explorer
Plug 'sjl/gundo.vim'                  " visualize undo tree
Plug 'vim-airline/vim-airline'        " lean & mean status/tabline
Plug 'vim-airline/vim-airline-themes' " themes for vim-airline

" Integrations
Plug 'ludovicchabant/vim-gutentags'   " automatic ctags
Plug 'mileszs/ack.vim'                " Ack wrapper
Plug 'tpope/vim-fugitive'             " Git wrappers

" Edit
Plug 'tpope/vim-surround'             " quoting/parenthesizing made simple
Plug 'tpope/vim-unimpaired'           " pairs of handy bracket mappings

" Language / Syntax
Plug 'tpope/vim-git'                  " filetype=gitcommit
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'   " filetype=markdown
Plug '~/.vim/bundle/mumps'            " filetype=mumps

" Other
Plug 'kopischke/vim-fetch'            " handle opening filenames with line+column numbers
Plug 'tpope/vim-scriptease'           " misc collection of helper commands
Plug '~/.vim/bundle/airlinetheme-map' " override AirlineTheme for certain colorscheme's
Plug '~/.vim/bundle/autofolds'        " folds for my *rc files

call plug#end()

" Automatic install
if empty(glob('~/.vim/plugged'))
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" ----------------------------------------------------------------------------
"  Plugin Settings
" ----------------------------------------------------------------------------

" NERDTree
let NERDTreeShowHidden=1              " show dotfiles by default
let NERDTreeMinimalUI=1               " disable 'Press ? for help' text

" Ctrl-P
let g:ctrlp_map = ''
let g:ctrlp_show_hidden = 1
let g:ctrlp_cache_dir = $HOME.'/.vim/.cache/ctrlp'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']

" Airline
let g:airline_mode_map = {
  \ '__' : '-',
  \ 'n'  : 'N',
  \ 'i'  : 'I',
  \ 'R'  : 'R',
  \ 'c'  : 'C',
  \ 'v'  : 'V',
  \ 'V'  : 'V',
  \ '' : 'V',
  \ 's'  : 'S',
  \ 'S'  : 'S',
  \ '' : 'S',
  \ }
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
if has("gui_running")
  let g:airline_powerline_fonts = 1   " use powerline font symbols
else
  let g:airline_symbols_ascii = 1     " use plain ascii symbols
  let g:airline_symbols.branch = 'BR:'
endif
let g:airline_symbols.linenr = ''
let g:airline_symbols.maxlinenr = ''

" gitgutter
let g:gitgutter_enabled = 0           " disable by default

" goyo + limelight
let g:goyo_width = 80
let g:limelight_conceal_ctermfg = 240
let g:limelight_default_coefficient = 0.6
let g:limelight_paragraph_span = 1    " show adjacent paragraphs
let g:limelight_priority = -1         " don't overrule hlsearch

function! s:goyo_enter()
  if exists('$TMUX')
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  endif
  set scrolloff=999
  Limelight
endfunction

function! s:goyo_leave()
  if exists('$TMUX')
    silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  endif
  set scrolloff=4
  Limelight!
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" pandoc
let g:pandoc#syntax#conceal#use = 0   " disable conceal pretty display
let g:pandoc#folding#fdc = 0          " disable foldcolumn
let g:pandoc#folding#level = 6        " open all folds by default

" gutentags
let g:gutentags_enabled_user_func = 'GutentagsCheckEnabled'
function! GutentagsCheckEnabled(file)
  let file_path = fnamemodify(a:file, ':p:h')

  " enable gutentags if ctags file already exists
  " tip: `touch tags` in project root to enable gutentags auto-updating
  try
    let gutentags_root = gutentags#get_project_root(file_path)
    if filereadable(gutentags_root . '/tags')
      return 1
    endif
  catch
  endtry

  return 0
endfunction

" ---------------------------------------------------------------------------
" Terminal Settings
" ---------------------------------------------------------------------------

if !has("gui_running") && !(&term =~ '256color')
  if has("terminfo") && ! (&term == 'linux' || &term == 'Eterm' || &term == 'vt220' || &term == 'nsterm-16color' || &term == 'xterm-16color')
    " Force these terminals to accept my authority! (default)
    set t_Co=16
    set t_AB=[%?%p1%{8}%<%t%p1%{40}%+%e%p1%{92}%+%;%dm  " ANSI background
    set t_AF=[%?%p1%{8}%<%t%p1%{30}%+%e%p1%{82}%+%;%dm  " ANSI foreground
  elseif &term == 'term' || &term == 'rxvt' || &term == 'vt100' || &term == 'screen'
    " Less-Cool Terminals (no terminfo)
    set t_Co=16
    set t_AB=[%?%p1%{8}%<%t4%p1%d%e%p1%{32}%+%d;1%;m
    set t_AF=[%?%p1%{8}%<%t3%p1%d%e%p1%{22}%+%d;1%;m
  else
    " Terminals that have trustworthy terminfo entries
    if &term == 'vt220'
      set t_Co=8
      set t_Sf=[3%dm  " foreground
      set t_Sb=[4%dm  " background
    elseif $TERM == 'xterm'
      set term=xterm-color
    endif
  endif
endif

" ---------------------------------------------------------------------------
" Colors / Theme
" ---------------------------------------------------------------------------

if &t_Co > 2 || has("gui_running")
  set background=dark                 " dark background
  syntax enable                       " syntax highligting

  " override colors in solarized colorscheme
  augroup vimrc_colorscheme_solarized
    autocmd!
    if !has("gui_running")
      " override Normal ctermfg
      autocmd ColorScheme solarized highlight Normal ctermfg=None
      " override Comment ctermfg
      if &t_Co == 256
        autocmd ColorScheme solarized highlight Comment ctermfg=241
      else
        autocmd ColorScheme solarized highlight Comment ctermfg=DarkGrey
      endif
      " override visual block
      autocmd ColorScheme solarized highlight Visual term=reverse cterm=reverse ctermfg=DarkGreen ctermbg=White
      if &t_Co < 256
        " override unprintable chars (listchars)
        autocmd ColorScheme solarized highlight SpecialKey ctermfg=DarkGrey ctermbg=Black
      endif
    endif
  augroup END

  " colorscheme theme options
  let g:solarized_termcolors=&t_Co    " use 256 colors for solarized
  let g:solarized_termtrans=1

  if !exists('s:set_colorscheme')
    colorscheme solarized
    let s:set_colorscheme=1
  endif

  " airline theme options
  let g:solarized16_termcolors=16     " always use 16 colors for 'solarized16' vim-airline theme
  let g:colorscheme_airlinetheme_map = {
        \ 'seoul256-light': 'zenburn',
        \ 'solarized': 'solarized16',
        \ }
  let g:colorscheme_airlinetheme_default = 'distinguished'

endif

" ----------------------------------------------------------------------------
"  Backups
" ----------------------------------------------------------------------------

set nobackup                           " do not keep backups after close
set nowritebackup                      " do not keep a backup while working
set backupcopy=yes                     " keep attributes of original file
set backupskip=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*
set directory=.,~/tmp,~/.vim/swap      " swap file directory-order
set updatetime=1000                    " idle time before writing swap file to disk

" ----------------------------------------------------------------------------
"  UI
" ----------------------------------------------------------------------------

set ruler                  " show the cursor position all the time
set showcmd                " display incomplete commands
set nolazyredraw           " turn off lazy redraw
set hidden                 " keep buffers loaded when hidden
set showmode               " show mode at bottom of screen
set wildmenu               " turn on wild menu
set wildmode=list:longest,full
set cmdheight=2            " command line height
set backspace=2            " allow backspacing over everything in insert mode
set whichwrap+=<,>,h,l,[,] " backspace and cursor keys wrap to
set shortmess=filtIoO      " shorten messages
set report=0               " tell us about changes
set nostartofline          " don't jump to the start of line when scrolling
set scrolloff=4            " vertical padding
set sidescroll=40          " side-scrolling increment (for nowrap mode)
set sidescrolloff=10       " horz padding
set tabpagemax=15          " open 15 tabs max
set splitright             " put new vsplit windows to the right of the current

" ----------------------------------------------------------------------------
" Visual Cues
" ----------------------------------------------------------------------------

set showmatch              " brackets/braces that is
set matchtime=5            " duration to show matching brace (1/10 sec)
set incsearch              " do incremental searching
set laststatus=2           " always show the status line
set ignorecase             " ignore case when searching
set smartcase              " case-sensitive if search contains an uppercase character
set visualbell             " shut the heck up
set hlsearch               " highlight all search matches
set list listchars=trail:·,tab:▸\ ,precedes:<,extends:>  " show trailing whitespace and tab chars

" ----------------------------------------------------------------------------
" Status Line
" ----------------------------------------------------------------------------

if !exists(':AirlineTheme')
  set statusline=%1*\ %n%0*\ %<%f  " buffer #, filename
  set statusline+=\ %h%m%r   " file-state flags
  set statusline+=%=         " left-right divider
  set statusline+=%{strlen(&fenc)?&fenc:&enc},%{&ff}\ %y  " file-encoding, format, type
  set statusline+=\ %12.(%v,%l/%L%)\ \ %-4P  " cursor position, % through file of viewport
endif

" ----------------------------------------------------------------------------
" Text Formatting
" ----------------------------------------------------------------------------

set autoindent             " automatic indent new lines
set smartindent            " be smart about it
set nowrap                 " do not wrap lines
set softtabstop=2          " yep, two
set shiftwidth=2           " ..
set tabstop=4
set expandtab              " expand tabs to spaces
set smarttab               " smarter softtab handling
set formatoptions+=n       " support for numbered/bullet lists
set textwidth=0            " no line-wrapping by default
set virtualedit=block      " allow virtual edit in visual block ..
set spelllang=en_us        " spell-check dictionary

" ----------------------------------------------------------------------------
" Filename Exclusions
" ----------------------------------------------------------------------------

set wildignore+=.hg,.git,.svn         " version control directories
set wildignore+=*.jpg,*.jpeg,*.bmp,*.gif,*.png  " image files
set wildignore+=*.o,*.obj,*.exe,*.dll " compiled object files
set wildignore+=*.pyc                 " Python byte code
set wildignore+=*.sw?                 " Vim swap files
set wildignore+=.DS_Store             " OSX junk

" ----------------------------------------------------------------------------
"  Key Mappings
" ----------------------------------------------------------------------------

" movement based on display lines not physical lines (sane movement with wrap turned on)
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
nnoremap <Down> gj
nnoremap <Up> gk
vnoremap <Down> gj
vnoremap <Up> gk
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk
" do not menu with left / right in command line
cnoremap <Left> <Space><BS><Left>
cnoremap <Right> <Space><BS><Right>

" reflow paragraph with Q in normal and visual mode
nnoremap Q gqap
vnoremap Q gq
" remap U to <C-r> for easier redo
nnoremap U <C-r>
" make Y consistent with C (c$) and D (d$)
nnoremap Y y$
" disable default vim regex handling for searching
nnoremap / /\v
vnoremap / /\v
" reselect visual block after indent/outdent
vnoremap < <gv
vnoremap > >gv

" <Space> to turn off highlighting and clear any message already displayed.
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

" leader-based keyboard shortcuts
let mapleader = ","
" CtrlP
nmap <leader>b :CtrlPBuffer<CR>
nmap <leader>o :CtrlP<CR>
nmap <leader>O :CtrlPClearCache<CR>:CtrlP<CR>
" NERDTree
nmap <leader>d :NERDTreeToggle<CR>
nmap <leader>f :NERDTreeFind<CR>
" Gundo
nmap <leader>u :GundoToggle<CR>
" Fugitive (Git)
nmap <leader>gb :Gblame<CR>
nmap <leader>gs :Gstatus<CR>
nmap <leader>gd :Gdiff<CR>
nmap <leader>gl :Glog<CR>
nmap <leader>gc :Gcommit<CR>
nmap <leader>gp :Gpush<CR>
" cd to the directory containing the file in the buffer
nmap <leader>cd :lcd %:h<CR>
" toggle quickfix window
function! QuickfixToggle()
  let wcnt_old = winnr("$")
  cwindow
  let wcnt_cur = winnr("$")
  if wcnt_old == wcnt_cur
    cclose
  endif
endfunction
nmap <leader>cc :call QuickfixToggle()<CR>
" toggle diffmode for a buffer
function! DiffToggle()
  if &diff
    diffoff
  else
    diffthis
  endif
endfunction
nmap <leader>df :call DiffToggle()<CR>
" quickly edit/reload vimrc
nmap <leader>ev :edit $MYVIMRC<CR>
nmap <leader>sv :source $MYVIMRC<CR>
" find merge conflict markers
nmap <leader>fc <ESC>/\v^[<=>]{7}( .*\|$)<CR>
" markdown headings
nnoremap <leader>h1 m`yypVr=``
nnoremap <leader>h2 m`yypVr-``
nnoremap <leader>h3 m`^i### <esc>``4l
nnoremap <leader>h4 m`^i#### <esc>``5l
nnoremap <leader>h5 m`^i##### <esc>``6l
" toggle hlsearch
nmap <leader>hls :set hlsearch! hlsearch?<CR>
" upper/lower word
nmap <leader>wu mQviwU`Q
nmap <leader>wl mQviwu`Q
" upper/lower first char of word
nmap <leader>wU mQgewvU`Q
nmap <leader>wL mQgewvu`Q
" smart paste - enable paste-mode and paste contents of system clipboard
map <leader>p :set paste<CR>o<esc>"*]p:set nopaste<cr>
" toggle spell-check
nmap <leader>sp :setlocal spell! spell?<CR>
" set text wrapping toggles
nmap <leader>tw :set wrap! wrap?<CR>
" set list-whitespace-chars toggle
nmap <leader>ws :set list! list?<CR>
" open tag definition in a horz split
nmap <leader>tag :split <CR>:exec("tag ".expand("<cword>"))<CR>
" gitgutter
nmap <leader>ht :GitGutterToggle<CR>
nmap <leader>hp <Plug>GitGutterPreviewHunk
nmap <leader>hu <Plug>GitGutterUndoHunk
nmap <leader>hs <Plug>GitGutterStageHunk
" goyo
nnoremap <leader>G :Goyo<CR>

" --------------------------------------------------------------------------
" Functions
" --------------------------------------------------------------------------

" :Redir
" Run vim command, redirect output to a scratch buffer
function! s:redir(cmd)
  redir => message
  silent execute a:cmd
  redir END
  if empty(message)
    echoerr "no output"
  else
    new
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
    silent! put=message
    silent! g/^s*$/d
  endif
endfunction
command! -nargs=+ -complete=command Redir call s:redir(<q-args>)

" :ListLeaders
" Make a scratch buffer with all of the leader keybindings.
command! ListLeaders :call s:redir('nmap <leader>')

" :Todo
" Use `git grep` to search for to-do comments, add matches to qflist
function! s:todo() abort
  let entries = []
  for cmd in ['git grep -nI -e TODO -e FIXME -e XXX 2> /dev/null',
            \ 'grep -rnI -e TODO -e FIXME -e XXX * 2> /dev/null']
    let lines = split(system(cmd), '\n')
    if v:shell_error != 0 | continue | endif
    for line in lines
      let [fname, lno, text] = matchlist(line, '^\([^:]*\):\([^:]*\):\(.*\)')[1:3]
      call add(entries, { 'filename': fname, 'lnum': lno, 'text': text })
    endfor
    break
  endfor

  if !empty(entries)
    call setqflist(entries)
    copen
  endif
endfunction
command! Todo call s:todo()

" :StripTrailingWhitespace
" Strip trailing whitespace
function! StripTrailingWhitespace()
  " preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " do the business
  %s/\s\+$//e
  " clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction
command! StripTrailingWhitespace call StripTrailingWhitespace()

" ---------------------------------------------------------------------------
" Auto Commands / File Types
" ---------------------------------------------------------------------------

" override Filetype settings
augroup vimrc_filetype
  autocmd!
  " sh config
  au Filetype sh,bash setlocal ts=4 sts=4 sw=4 expandtab
  let g:is_bash = 1
  " git commit message: enable spell checking
  au Filetype gitcommit setlocal spell
  " gitconfig file: use real tabs
  au Filetype gitconfig setlocal noexpandtab
  " javascript: don't use cindent
  au FileType javascript setlocal nocindent
  " makefiles: use real tabs
  au FileType make setlocal noexpandtab
  " autofolds
  au FileType vim setlocal foldmethod=expr foldexpr=autofolds#foldexpr(v\:lnum) foldtext=autofolds#foldtext() foldlevel=2
  au FileType sh setlocal foldmethod=expr foldexpr=autofolds#foldexpr(v\:lnum,'sh') foldtext=autofolds#foldtext() foldlevel=2
augroup END

" --------------------------------------------------------------------------
" Local Settings
" --------------------------------------------------------------------------

if filereadable(glob("~/.vimrc.local"))
  source ~/.vimrc.local
endif
