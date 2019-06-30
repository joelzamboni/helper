" Basic Settings
syntax on
filetype on
filetype plugin indent on
set number relativenumber
set numberwidth=1
set title
set ruler
set wildmenu
set wildmode=longest,list,full
set showcmd
set nocompatible
set cursorline
set colorcolumn=80

set autoindent
set smartindent
set shiftwidth=2
set tabstop=2
set expandtab
set backspace=indent,eol,start
set mouse=a
set modeline

set path+=** 
set laststatus=2

set ls=2  "Always show status line"
set t_Co=256
set nu rnu
autocmd Filetype py setlocal tabstop=4


" NETRW
" hide netrw top message
let g:netrw_banner = 0
" tree listing by default
let g:netrw_liststyle = 3
" open files in left window by default
let g:netrw_chgwin=1
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25
" Automatically open NETRW
"augroup ProjectDrawer
"  autocmd!
"  autocmd VimEnter * :Vexplore
"augroup END

" Python
"au BufRead *.py compiler nose
au FileType python set omnifunc=pythoncomplete#Complete
au FileType python setlocal expandtab shiftwidth=4 tabstop=4 smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class,with
au BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
au FileType python set foldmethod=indent foldlevel=99
" Add the virtualenv 
if has('python')
py << EOF
import os.path
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF
endif
" Load up virtualenv's vimrc if it exists
if filereadable($VIRTUAL_ENV . '/.vimrc')
    source $VIRTUAL_ENV/.vimrc
endif
