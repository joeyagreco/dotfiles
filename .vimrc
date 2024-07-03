syntax on

set number

" Disable compatibility with vi which can cause unexpected issues.
set nocompatible

" case insensitive search
set ignorecase

set smartcase

colorscheme desert

" makes backspace work
set backspace=indent,eol,start
filetype plugin indent on

" Highlight cursor line underneath the cursor horizontally.
set cursorline

" While searching though a file incrementally highlight matching characters as
" you type.
set incsearch

" highlights matching parentheses/brackets/etc
set showmatch

" persist undos even after closing file
set undofile

" do not wrap lines. they can go as long as they need to
set nowrap

" Show partial command you type in the last line of the screen.
set showcmd

" Set the commands to save in history default number is 20.
set history=1000

" There are certain files that we would never want to edit with Vim.
" Wildmenu will ignore files with these extensions.
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

" number of spaces per tab
set softtabstop=4

set smarttab
set smartindent
