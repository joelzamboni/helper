" - Step 1: Place this file on ${HOME}/.vimrc
" - Step 2: Install Pathogen for modules loading
" mkdir -p ~/.vim/autoload ~/.vim/bundle
" curl -so ~/.vim/autoload/pathogen.vim \
"   https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim
" - Step 3: Install additional modules
"   git clone https://github.com/moll/vim-node.git ~/.vim/bundle/node
"   git clone https://github.com/godlygeek/tabular.git ~/.vim/bundle/tabular
"   git clone https://github.com/pangloss/vim-javascript.git ~/.vim/bundle/vim-javascript
"   git clone https://github.com/digitaltoad/vim-jade.git ~/.vim/bundle/vim-jade
"   git clone https://github.com/kchmck/vim-coffee-script.git ~/.vim/bundle/vim-coffee-script
"   git clone https://github.com/wavded/vim-stylus.git ~/.vim/bundle/vim-stylus
"   git clone https://github.com/groenewege/vim-less.git ~/.vim/bundle/vim-less
"   git clone https://github.com/tpope/vim-surround.git ~/.vim/bundle/vim-surround
"   git clone https://github.com/scrooloose/nerdcommenter.git ~/.vim/bundle/nerdcommenter
"   git clone https://github.com/scrooloose/nerdtree.git ~/.vim/bundle/nerdtree
"   git clone https://github.com/tomtom/tlib_vim.git ~/.vim/bundle/tlib_vim
"   git clone https://github.com/MarcWeber/vim-addon-mw-utils.git ~/.vim/bundle/vim-addon-mw-utils
"   git clone https://github.com/garbas/vim-snipmate.git ~/.vim/bundle/vim-snipmate
"   git clone https://github.com/honza/vim-snippets.git ~/.vim/bundle/vim-snippets
"   git clone https://github.com/scrooloose/snipmate-snippets.git ~/vim/bundle/snipmate-snippets.git
"   git clone https://github.com/scrooloose/syntastic.git ~/.vim/bundle/syntastic
"   git clone https://github.com/tpope/vim-fugitive.git ~/.vim/bundle/fugitive
"
" Some testing:
" - Listing loaded plugins
" :scriptnames
"
" - Listing available commands:
" :command
"
set nocompatible                              " use VIM settings
set backspace=indent,eol,start                " allow backspace
set history=1000                              " number of commands in history
set wrap                                      " dont wrap lines
set linebreak                                 " wrap lines at convenient points
set smartindent                               " smart autoindenting when starting a new line
set shiftwidth=2                              " number of spaces to use for each step of (auto)indent
set tabstop=2                                 " number of spaces that a Tab in the file counts for
set expandtab                                 " use spaces to insert a Tab
set smarttab                                  " insert or delete (backspace) Tabs
set autoindent                                " copy indent from current line when starting a new line
call pathogen#infect()                        " call pathogen
filetype plugin on                            " load file type plugin
filetype indent on                            " load file indent plugin
syntax on                                     " enable syntax
set scrolloff=999                             " cursor will be always in the middle of the window
set encoding=utf-8                            " sets the character encoding
colorscheme elflord                           " seting color theme
set mouse=a                                   " set all mouse modes
set ttymouse=xterm2                           " mouse compatible term
set visualbell                                " no beep
set laststatus=2                              " always statusline
set statusline=                               " clean the status line
set statusline+=%-3.3n\                       " buffer number
set statusline+=%f\                           " filename
set statusline+=%h%m%r%w                      " status flags
set statusline+=\[%{strlen(&ft)?&ft:'none'}]  " file type
set statusline+=%=                            " right align remainder
set statusline+=0x%-8B                        " character value
set statusline+=%-14(%l,%c%V%)                " line, character
set statusline+=%<%P                          " file position
set ruler                                     " show the line and column number of the cursor position
set colorcolumn=80                            " create a line on column 80
set showcmd                                   " show incomplete cmds down the bottom
set showmode                                  " show current mode down the botto
set number                                    " show line numbers (set nonumber to remove)
set list                                      " display tabs and trailing spaces
set listchars=tab:▷⋅,trail:⋅,nbsp:⋅           " define symbolx for tabs
set incsearch                                 " find the next match as we type the search
set hlsearch                                  " hilight searches by default
set ignorecase
set wildmode=list:longest                     " make cmdline tab completion similar to bash
set wildmenu                                  " enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~                   " stuff to ignore when tab completing
set clipboard=unnamedplus                     " use X11 clipboard
" Customization to modules
" open NERDTree with <ne>
nmap ne :NERDTree<cr>
" improved split navegation Ctrl+key, instead of Ctrl+w+key
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
