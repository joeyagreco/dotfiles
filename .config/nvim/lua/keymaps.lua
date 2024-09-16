local telescope_builtin = require("telescope.builtin")
local telescope = require("telescope")
local nvim_tree = require("nvim-tree.api")
local git_signs = require("gitsigns")
local comment = require("Comment.api")
local ufo = require("ufo")
local helpers = require("helpers")

-- keep track of custom keymaps by letter to prevent collision delay
-- C
-- cn
-- e
-- E
-- f
-- gd
-- gp
-- gr
-- gR
-- ho
-- K
-- l
-- L
-- o
-- qo
-- qx
-- Q
-- r
-- R
-- s
-- u
-- w
-- /

local default_options = { noremap = true, silent = true }
local map = vim.keymap.set

------------
-- SEARCH --
------------

-- search for a word
-- https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md
map(
    "n",
    "<leader>s",
    telescope.extensions.live_grep_args.live_grep_args,
    helpers.combine_tables(default_options, { desc = "search for words" })
)

-- find files
map("n", "<leader>f", telescope_builtin.find_files, helpers.combine_tables(default_options, { desc = "find files" }))

-- go to definition for whatever the cursor is on
map(
    "n",
    "<leader>gd",
    vim.lsp.buf.definition,
    helpers.combine_tables(default_options, { desc = "go to definition for word under cursor" })
)

-- find old (open up telescope search with previous search)
map(
    "n",
    "<leader>o",
    telescope_builtin.resume,
    helpers.combine_tables(default_options, { desc = "resume previous search" })
)

-- toggle recent files scoped to this directory
map("n", "<leader>r", function()
    telescope_builtin.oldfiles({ cwd = vim.fn.getcwd() })
end, helpers.combine_tables(default_options, { desc = "see recent files" }))

-- toggle recent files with no scope (show all recent files)
map(
    "n",
    "<leader>R",
    telescope_builtin.oldfiles,
    helpers.combine_tables(default_options, { desc = "see recent files" })
)

---------
-- LSP --
---------

-- get lsp info for whatever the cursor is on
map(
    "n",
    "K",
    vim.lsp.buf.hover,
    helpers.combine_tables(default_options, { desc = "see lsp info for word under cursor" })
)

-- find usages (references) for whatever cursor is on
map(
    "n",
    "<leader>u",
    telescope_builtin.lsp_references,
    helpers.combine_tables(default_options, { desc = "find references" })
)

-- rename symbol (change name)
map("n", "<leader>cn", vim.lsp.buf.rename, helpers.combine_tables(default_options, { desc = "rename symbol" }))

-- see lsp info
map("n", "<leader>L", function()
    vim.diagnostic.open_float(nil, { source = "always" })
end, helpers.combine_tables(default_options, { desc = "see lsp info with source" }))

---------
-- GIT --
---------

-- reset current cursor hunk
map(
    "n",
    "<leader>gr",
    git_signs.reset_hunk,
    helpers.combine_tables(default_options, { desc = "git reset current hunk" })
)

-- reset all hunks in current file/buffer
map(
    "n",
    "<leader>gR",
    git_signs.reset_buffer,
    helpers.combine_tables(default_options, { desc = "git reset current buffer" })
)

-- preview current cursor hunk
map(
    "n",
    "<leader>gp",
    git_signs.preview_hunk,
    helpers.combine_tables(default_options, { desc = "git preview current hunk" })
)

-------------
-- GENERAL --
-------------

-- quit vim
map("n", "<leader>Q", ":qa<CR>", helpers.combine_tables(default_options, { desc = "exit vim" }))

-- disable space in normal and visual mode
map(
    { "n", "v" },
    "<Space>",
    "<Nop>",
    helpers.combine_tables(default_options, { desc = "disabled space in normal and visual mode" })
)

-- redo
map("n", "U", "<C-r>", helpers.combine_tables(default_options, { desc = "redo" }))

-- comment out / uncomment line and selection
map(
    "n",
    "<leader>/",
    comment.toggle.linewise.current,
    helpers.combine_tables(default_options, { desc = "comment current line" })
)

map(
    "v",
    "<leader>/",
    '<ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>',
    helpers.combine_tables(default_options, { desc = "comment current selection" })
)

-- close tab
map("n", "<leader>C", ":tabc<CR>", helpers.combine_tables(default_options, { desc = "close tab" }))

-- open quickfix list
map("n", "<leader>qo", ":copen<CR>", helpers.combine_tables(default_options, { desc = "open quickfix list" }))

-- close quickfix list
map("n", "<leader>qx", ":cclose<CR>", helpers.combine_tables(default_options, { desc = "close quickfix list" }))

-- -- open location list
-- map("n", "<leader>lo", ":lopen<CR>", helpers.combine_tables(default_options, { desc = "open location list" }))
--
-- -- close location list
-- map("n", "<leader>lx", ":lclose<CR>", helpers.combine_tables(default_options, { desc = "close location list" }))

-- go to last buffer
map("n", "<leader>l", "<C-^>", helpers.combine_tables(default_options, { desc = "go to last buffer" }))

-- toggle on / focus on explorer
map("n", "<leader>e", function()
    nvim_tree.tree.open({ focus = true })
end, helpers.combine_tables(default_options, { desc = "open / focus explorer" }))

-- focus from nvim tree -> main buffer
map(
    "n",
    "<leader>E",
    ":wincmd l<CR>",
    helpers.combine_tables(default_options, { desc = "focus from nvim tree -> main buffer" })
)

-- 'if __name__ == "__main__"'
map(
    "n",
    "<leader>inm",
    'iif __name__ == "__main__":<Esc>o',
    helpers.combine_tables(default_options, { desc = "if name == main" })
)

-- turn search highlighting off
map(
    "n",
    "<leader>ho",
    ":nohlsearch<CR>",
    helpers.combine_tables(default_options, { desc = "turn off vim search highlights" })
)

-- make "x" not copy text
map("n", "x", '"_x', helpers.combine_tables(default_options, { desc = "make 'x' not copy text" }))

-- Using ufo provider need remap `zR` and `zM`
map("n", "zR", ufo.openAllFolds, helpers.combine_tables(default_options, { desc = "ufo open all folds" }))
map("n", "zM", ufo.closeAllFolds, helpers.combine_tables(default_options, { desc = "ufo open all folds" }))

-- keep selection selected after > and <
map("v", ">", ">gv", helpers.combine_tables(default_options, { desc = "keep selection selected after >" }))
map("v", "<", "<gv", helpers.combine_tables(default_options, { desc = "keep selection selected after <" }))
