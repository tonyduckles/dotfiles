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
Plug 'altercation/vim-colors-solarized'
Plug 'kien/ctrlp.vim'
Plug 'kopischke/vim-fetch'
Plug 'mileszs/ack.vim'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'sjl/gundo.vim'
Plug 'tangledhelix/vim-octopress'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-scriptease'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug '~/.vim/bundle/matchit'
Plug '~/.vim/bundle/mumps'
Plug '~/.vim/bundle/whitespace'
call plug#end()

" Automatic install
if empty(glob('~/.vim/plugged'))
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

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

  if &t_Co == 256
    let g:solarized_termcolors=256    " use 256 colors for solarized
  endif
  colorscheme solarized
  let g:airline_theme='solarized16'   " vim-airline theme
  let g:solarized16_termcolors=16     " always use 16 colors for 'solarized16' vim-airline theme
endif

" ---------------------------------------------------------------------------
"  Highlight (Colors)
" ---------------------------------------------------------------------------

" always use terminal's default bg color
highlight Normal ctermbg=None
" comments
highlight Comment ctermfg=DarkGrey
" visual block
highlight Visual term=reverse cterm=reverse ctermfg=DarkGreen ctermbg=White
if &t_Co < 256 && !has("gui_running")
  " unprintable chars (listchars)
  highlight SpecialKey ctermfg=DarkGrey ctermbg=Black
endif

" ----------------------------------------------------------------------------
"  Backups
" ----------------------------------------------------------------------------

set nobackup                           " do not keep backups after close
set nowritebackup                      " do not keep a backup while working
set backupcopy=yes                     " keep attributes of original file
set backupskip=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*
set directory=.,~/tmp,~/.vim/swap      " swap file directory-order

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
  let g:airline_powerline_fonts = 1  " use powerline font symbols
else
  let g:airline_symbols_ascii = 1  " use plain ascii symbols
  let g:airline_symbols.branch = 'BR:'
endif
let g:airline_symbols.linenr = ''
let g:airline_symbols.maxlinenr = ''

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
" Filename exclusions
" ----------------------------------------------------------------------------

set wildignore+=.hg,.git,.svn         " version control directories
set wildignore+=*.jpg,*.jpeg,*.bmp,*.gif,*.png  " image files
set wildignore+=*.o,*.obj,*.exe,*.dll " compiled object files
set wildignore+=*.pyc                 " Python byte code
set wildignore+=*.sw?                 " Vim swap files
set wildignore+=.DS_Store             " OSX junk

" ----------------------------------------------------------------------------
"  Tabs
" ----------------------------------------------------------------------------

if version >= 700
  set tabpagemax=50        " open 50 tabs max
endif

" ----------------------------------------------------------------------------
"  Mappings
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
" toggle diffmode for a buffer
nmap <leader>df :call DiffToggle()<CR>
" quickly edit/reload vimrc
nmap <leader>ev :edit $MYVIMRC<CR>
nmap <leader>sv :source $MYVIMRC<CR>
" find merge conflict markers
nmap <leader>fc <ESC>/\v^[<=>]{7}( .*\|$)<CR>
" toggle hlsearch
nmap <leader>hs :set hlsearch! hlsearch?<CR>
" upper/lower word
nmap <leader>wu mQviwU`Q
nmap <leader>wl mQviwu`Q
" upper/lower first char of word
nmap <leader>wU mQgewvU`Q
nmap <leader>wL mQgewvu`Q
" smart paste - enable paste-mode and paste contents of system clipboard
map <leader>p :set paste<CR>o<esc>"*]p:set nopaste<cr>
" strip all trailing whitespace in file
nmap <leader>sw :call whitespace#strip_trailing()<CR>
" toggle spell-check
nmap <leader>sp :setlocal spell! spell?<CR>
" set text wrapping toggles
nmap <leader>tw :set wrap! wrap?<CR>
" set list-whitespace-chars toggle
nmap <leader>ws :set list! list?<CR>
" open tag definition in a horz split
nmap <leader>tag :split <CR>:exec("tag ".expand("<cword>"))<CR>

" --------------------------------------------------------------------------
" Functions
" --------------------------------------------------------------------------

" Toggle diff-mode
function! DiffToggle()
  if &diff
    diffoff
  else
    diffthis
  endif
endfunction

" Make a scratch buffer with all of the leader keybindings.
" Adapted from http://ctoomey.com/posts/an-incremental-approach-to-vim/
function! ListLeaders()
  silent! redir @b
  silent! nmap <LEADER>
  silent! redir END
  silent! new
  silent! set buftype=nofile
  silent! set bufhidden=hide
  silent! setlocal noswapfile
  silent! put! b
  silent! g/^s*$/d
  silent! %s/^.*,//
  silent! normal ggVg
  silent! sort
  silent! let lines = getline(1,"$")
  silent! normal <esc>
endfunction
command! ListLeaders :call ListLeaders()

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

" ---------------------------------------------------------------------------
" Auto Commands / File Types
" ---------------------------------------------------------------------------

augroup vimrc_autocmds
  " clear auto command group so we don't define it multiple times
  autocmd!
  " jump to last position of buffer when opening (but not for commit messages)
  au BufReadPost * if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$") |
                     \ exe "normal g'\"" | endif
  " sh config
  au Filetype sh,bash set ts=4 sts=4 sw=4 expandtab
  let g:is_bash = 1
  " git commit message
  au Filetype gitcommit set tw=68  spell
  " html variants
  au Filetype html,xml,xsl,rhtml source $HOME/.vim/scripts/closetag.vim
  " don't use cindent for javascript
  au FileType javascript setlocal nocindent
  " use Octopress syntax-highlighting for *.markdown files
  au BufNewFile,BufRead *.markdown set filetype=octopress  spell
  " in Makefiles, use real tabs not tabs expanded to spaces
  au FileType make setlocal noexpandtab
augroup END

" --------------------------------------------------------------------------
" ManPageView
" --------------------------------------------------------------------------

let g:manpageview_pgm= 'man -P "/usr/bin/less -is"'
let $MANPAGER = '/usr/bin/less -is'

" --------------------------------------------------------------------------
" Local Settings
" --------------------------------------------------------------------------

if filereadable(glob("~/.vimrc.local"))
  source ~/.vimrc.local
endif
