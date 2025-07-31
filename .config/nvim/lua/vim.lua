-- set leader to SPACE
local LEADER = " "
vim.g.mapleader = LEADER
vim.g.maplocalleader = LEADER

-- enable the live preview of substitution commands in a split window
vim.opt.inccommand = "split"

-- use system clipboard
vim.opt.clipboard = "unnamedplus"

-- no splash screen on startup
-- vim.opt.shortmess:append("I")
-- dont show the intro message when starting up
-- vim.opt.shortmess:append("atI")

-- enable smart indenting (see https://stackoverflow.com/questions/1204149/smart-wrap-in-vim)
vim.opt.breakindent = true

-- decrease updatetime to 250ms
-- https://neovim.io/doc/user/options.html#'updatetime'
vim.opt.updatetime = 250

-- enable the sign column to prevent the screen from jumping
vim.opt.signcolumn = "yes"

-- enable syntax highlighting
vim.cmd("syntax on")

-- keep n lines visible above or below the cursor at all times
vim.opt.scrolloff = 5
-- keep n lines visible to the left and right of the cursor at all times
vim.opt.sidescrolloff = 30

-- show line numbers
vim.opt.number = true
vim.opt.relativenumber = false

-- enable 24-bit RGB colors
vim.opt.termguicolors = true

-- disable compatibility with vi which can cause unexpected issues.
vim.opt.compatible = false

-- case insensitive search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- makes backspace work
vim.opt.backspace = { "indent", "eol", "start" }

-- enable filetype plugin and indent
vim.cmd("filetype plugin indent on")

-- highlight cursor line underneath the cursor horizontally.
vim.opt.cursorline = true

-- incremental search
vim.opt.incsearch = true

-- highlight matching parentheses/brackets/etc.
vim.opt.showmatch = true

-- persist undos even after closing file
vim.opt.undofile = true

-- do not wrap lines
vim.opt.wrap = false

-- show partial command in the last line of the screen
vim.opt.showcmd = true

-- set the commands to save in history, default number is 20.
vim.opt.history = 1000

-- enable wildmenu for : command autocomplete when <TAB> is pressed
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"
-- ignore specific file types in wildmenu
vim.opt.wildignore = "*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx"

-- number of spaces per tab
vim.opt.softtabstop = 4

-- enable smart tab and indent
vim.opt.smarttab = true
vim.opt.smartindent = true

-- disable perl
vim.g.loaded_perl_provider = 0
-- disable ruby
vim.g.loaded_ruby_provider = 0

-- -- stop things like Lazy from formatting
-- vim.g.autoformat = false

-- add the g flag to search/replace by default
vim.opt.gdefault = true

-- this is opt-in as of nvim 0.11.0
-- show diagnostics
vim.diagnostic.config({ virtual_text = true })

vim.opt.swapfile = false
