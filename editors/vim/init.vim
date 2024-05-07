syntax on
colorscheme evening
set autoindent
set shiftwidth=2
set tabstop=2
set softtabstop=2
set encoding=utf-8
set number relativenumber
set expandtab
set fileformat=unix
set list
" set listchars=tab:→\ ,trail:·,precedes:«,extends:»,eol:¬,nbsp:␣
set listchars=tab:→\ ,trail:·,precedes:«,extends:»,nbsp:␣
set clipboard=unnamed
set mouse=a
set cursorline
set cursorcolumn
set showmatch
set ruler
set hls                   "highlight all search
set is                    "incremental search
set cc=80                 "color column
filetype on
filetype indent on

if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif


function! ShellSkeleton()
  call append(0, "#!/usr/bin/env bash")
  call append(1, "[ \"${BASH_VERSINFO:-0}\" -ge 4 ] || { echo \"Upgrade your bash to at least version 4\"; exit 1; }")
  call append(2, "")
  call append(3, "set -euo pipefail")
  call append(4, "")
endfunction

" Python
augroup python
  autocmd!
  silent autocmd BufNewFile,BufRead *.py set tabstop=4 softtabstop=4 shiftwidth=4
  silent autocmd FileType python map <C-p> :w<CR>:!python3 %<CR>
augroup END

" Shell
augroup sh
  autocmd!
  autocmd BufNewFile *.sh call ShellSkeleton()
  silent autocmd BufNewFile,BufRead *.sh set tabstop=2 softtabstop=2 shiftwidth=2
  silent autocmd FileType sh map <C-p> :w<CR>:!bash %<CR>
augroup END

" Javascript, HTML, CSS, YAML specifc settings
augroup web
  autocmd!
  silent autocmd BufNewFile,BufRead *.js,*.html,*.css,*.yaml set tabstop=2 softtabstop=2 shiftwidth=2
augroup END

" Go specific settings (Not working)
augroup go
  autocmd!
  silent autocmd BufNewFile,BufRead *.go set noexpandtab softtabstop=0 shiftwidth=8 tabstop=8
augroup END


" set exrc
" set secure

" Neovim specific settings
set termguicolors
set undodir=~/.config/nvim/undo
set undofile
