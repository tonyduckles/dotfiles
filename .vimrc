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
"  Pathogen Init (Bundles)
" ---------------------------------------------------------------------------
filetype off
call pathogen#infect()
call pathogen#helptags()
filetype plugin indent on             " enable plugins, detection and indenting in one step

" ---------------------------------------------------------------------------
" Colors / Theme
" ---------------------------------------------------------------------------

if &t_Co > 2 || has("gui_running")
  if has("terminfo")
    set t_Co=16
    set t_AB=[%?%p1%{8}%<%t%p1%{40}%+%e%p1%{92}%+%;%dm
    set t_AF=[%?%p1%{8}%<%t%p1%{30}%+%e%p1%{82}%+%;%dm
  else
    set t_Co=16
    set t_Sf=[3%dm
    set t_Sb=[4%dm
  endif

  set background=dark                 " dark background
  syntax enable                       " syntax highligting

  " Define to-do color(s)
  if !exists("autocmd_colorscheme_loaded")
    let autocmd_colorscheme_loaded = 1
    autocmd ColorScheme * highlight TodoRed ctermbg=LightRed guibg=#E01B1B ctermfg=White guifg=#002b37
  endif

  " Solarized color-scheme
  let g:solarized_termtrans=1  " Always use terminal's default bg color
  colorscheme solarized

  " Auto-highlight TODO's
  if has("autocmd")
    if v:version > 701
      autocmd Syntax * call matchadd('TodoRed',  '\W\zs\(TODO\)')
    endif
  endif
endif

" ---------------------------------------------------------------------------
"  Highlight (Colors)
" ---------------------------------------------------------------------------

" comments
highlight Comment                                    ctermfg=DarkGrey                    guifg=#425257
" visual block
highlight Visual          term=reverse cterm=reverse ctermfg=DarkGreen ctermbg=White     guifg=#4d830a guibg=#fdf6e3
" statusline (active vs inactive)
highlight StatusLine      term=reverse cterm=reverse ctermfg=Black     ctermbg=Grey      guifg=#073642 guibg=#93A1A1
highlight StatusLineNC    term=reverse cterm=reverse ctermfg=Black     ctermbg=DarkGrey  guifg=#073642 guibg=#37555c
highlight User1           term=reverse cterm=reverse ctermfg=Black     ctermbg=DarkGreen guifg=#4d830a guibg=#073642
" unprintable chars (listchars)
highlight SpecialKey                                 ctermfg=DarkGray  ctermbg=Black     guifg=#374549 guibg=#06313c

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

set statusline=%1*\ %n%0*\ %<%f  " buffer #, filename
set statusline+=\ %h%m%r   " file-state flags
set statusline+=%=         " left-right divider
set statusline+=%{strlen(&fenc)?&fenc:&enc},%{&ff}\ %y  " file-encoding, format, type
set statusline+=\ %12.(%v,%l/%L%)\ \ %-4P  " cursor position, % through file of viewport

let g:airline_theme='solarized16'
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
let g:airline_symbols_ascii = 1  " use plain ascii symbols
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_symbols.branch = 'BR:'
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
" <F4> to toggle NERDTree
nnoremap <F4> :NERDTreeToggle<CR>
" <F5> to toggle Gundo
nnoremap <F5> :GundoToggle<CR>

" leader-based keyboard shortcuts
let mapleader = ","
" CtrlP
nmap <leader>b :CtrlPBuffer<CR>
nmap <leader>o :CtrlP<CR>
nmap <leader>O :CtrlPClearCache<CR>:CtrlP<CR>
" NERDTree
nmap <leader>d :NERDTreeToggle<CR>
nmap <leader>f :NERDTreeFind<CR>
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
" Ctrl-P
let g:ctrlp_map = ''
let g:ctrlp_show_hidden = 1
let g:ctrlp_cache_dir = $HOME.'/.vim/.cache/ctrlp'

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
