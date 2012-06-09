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

call pathogen#infect()                " enable pathogen (plugin bundles)
filetype plugin indent on             " load filetype plugin

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
  set hlsearch                        " highlight all search matches
  " Press <Space> to turn off highlighting and clear any message already displayed.
  :nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

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
"  Highlight
" ---------------------------------------------------------------------------

highlight Comment         ctermfg=DarkGrey guifg=#444444
highlight StatusLineNC    ctermfg=Black ctermbg=DarkGrey cterm=bold
highlight StatusLine      ctermbg=Black ctermfg=LightGrey

" ----------------------------------------------------------------------------
"   Highlight Trailing Whitespace
" ----------------------------------------------------------------------------

set list listchars=trail:.,tab:>.
highlight SpecialKey ctermfg=DarkGray ctermbg=Black

" ----------------------------------------------------------------------------
"  Backups
" ----------------------------------------------------------------------------

set nobackup                           " do not keep backups after close
set nowritebackup                      " do not keep a backup while working
"set noswapfile                         " don't keep swp files either
set backupdir=$HOME/.vim/backup        " store backups under ~/.vim/backup
set backupcopy=yes                     " keep attributes of original file
set backupskip=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*
set directory=.,~/tmp,~/.vim/swap      " swap file directory-order

" ----------------------------------------------------------------------------
"  UI
" ----------------------------------------------------------------------------

set ruler                  " show the cursor position all the time
set showcmd                " display incomplete commands
set nolazyredraw           " turn off lazy redraw
"set number                 " line numbers
set wildmenu               " turn on wild menu
set wildmode=list:longest,full
set cmdheight=2            " command line height
set backspace=2            " allow backspacing over everything in insert mode
set whichwrap+=<,>,h,l,[,] " backspace and cursor keys wrap to
set shortmess=filtIoO      " shorten messages
set report=0               " tell us about changes
set nostartofline          " don't jump to the start of line when scrolling
set scrolloff=4            " vertcal padding
set sidescroll=40          " side-scrolling increment (for nowrap mode)

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
set nosmarttab             " screw tabs
set formatoptions+=n       " support for numbered/bullet lists
"set textwidth=110          " wrap at 110 chars by default
set virtualedit=block      " allow virtual edit in visual block ..

" ----------------------------------------------------------------------------
"  Tabs
" ----------------------------------------------------------------------------

if version >= 700
  set tabpagemax=50        " open 50 tabs max
endif

" ----------------------------------------------------------------------------
"  Mappings
" ----------------------------------------------------------------------------

" <F2> to pastetoggle, to turn-off autoindent when pasting from system clipboard
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

"" <F8>/<Shift>-<F8> to navigation between buffers
if version >= 700
  set switchbuf=usetab
  nnoremap <F8> :sbnext<CR>
  nnoremap <S-F8> :sbprevious<CR>
endif

"" quickfix-window mappings
"map <F7>  :cn<CR>
"map <S-F7> :cp<CR>
"map <A-F7> :copen<CR>

"" <F5> to gundo
nnoremap <F5> :GundoToggle<CR>

"" emacs movement keybindings in insert mode
"imap <C-a> <C-o>0
"imap <C-e> <C-o>$
"map <C-e> $
"map <C-a> 0

" reflow paragraph with Q in normal and visual mode
nnoremap Q gqap
vnoremap Q gq

" sane movement with wrap turned on
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

" ----------------------------------------------------------------------------
"  Auto Commands
" ----------------------------------------------------------------------------

" jump to last position of buffer when opening
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") |
                         \ exe "normal g'\"" | endif

" ----------------------------------------------------------------------------
"  LookupFile
" ----------------------------------------------------------------------------

"let g:LookupFile_TagExpr = '".ftags"'
"let g:LookupFile_MinPatLength = 2
"let g:LookupFile_ShowFiller = 0                  " fix menu flashiness
"let g:LookupFile_PreservePatternHistory = 1      " preserve sorted history?
"let g:LookupFile_PreserveLastPattern = 0         " start with last pattern?
"
"nmap <unique> <silent> <D-f> <Plug>LookupFile
"imap <unique> <silent> <D-f> <C-O><Plug>LookupFile

" ----------------------------------------------------------------------------
"  PATH on MacOS X
" ----------------------------------------------------------------------------

if system('uname') =~ 'Darwin'
  let $PATH = $HOME .
    \ '/usr/local/bin:/usr/local/sbin:' .
    \ '/usr/pkg/bin:' .
    \ '/opt/local/bin:/opt/local/sbin:' .
    \ $PATH
endif

" ---------------------------------------------------------------------------
"  sh config
" ---------------------------------------------------------------------------

au Filetype sh,bash set ts=4 sts=4 sw=4 expandtab
let g:is_bash = 1

" ---------------------------------------------------------------------------
"  Misc mappings
" ---------------------------------------------------------------------------

"map ,f :tabnew <cfile><CR>
"map ,d :e %:h/<CR>
"map ,dt :tabnew %:h/<CR>

"" I use these commands in my TODO file
"map ,a o<ESC>:r!date +'\%A, \%B \%d, \%Y'<CR>:r!date +'\%A, \%B \%d, \%Y' \| sed 's/./-/g'<CR>A<CR><ESC>
"map ,o o[ ] 
"map ,O O[ ] 
"map ,x :s/^\[ \]/[x]/<CR>
"map ,X :s/^\[x\]/[ ]/<CR>

" ---------------------------------------------------------------------------
"  Strip all trailing whitespace in file
" ---------------------------------------------------------------------------

function! StripWhitespace ()
  exec ':%s/ \+$//gc'
endfunction
map ,s :call StripWhitespace ()<CR>

" ---------------------------------------------------------------------------
" File Types
" ---------------------------------------------------------------------------

au Filetype gitcommit set tw=68  spell
au Filetype html,xml,xsl,rhtml source $HOME/.vim/scripts/closetag.vim
" don't use cindent for javascript
au FileType javascript setlocal nocindent
" Use Octopress syntax-highlighting for *.markdown files
au BufNewFile,BufRead *.markdown set filetype=octopress

" --------------------------------------------------------------------------
" ManPageView
" --------------------------------------------------------------------------

let g:manpageview_pgm= 'man -P "/usr/bin/less -is"'
let $MANPAGER = '/usr/bin/less -is'

