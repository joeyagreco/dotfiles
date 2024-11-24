local helpers = require("helpers")

local default_options = { noremap = true, silent = true }
local map = vim.keymap.set

------------
-- SEARCH --
------------

-- go to definition for whatever the cursor is on
map(
    "n",
    "<leader>gd",
    vim.lsp.buf.definition,
    helpers.combine_tables(default_options, { desc = "go to definition for word under cursor" })
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

-- rename symbol (change name)
map("n", "<leader>cn", vim.lsp.buf.rename, helpers.combine_tables(default_options, { desc = "rename symbol" }))

-- see lsp info
map("n", "<leader>L", function()
    vim.diagnostic.open_float(nil, { source = "always" })
end, helpers.combine_tables(default_options, { desc = "see lsp info with source" }))

-- open relative file links, similar to 'gx'
vim.keymap.set("n", "gX", function()
    local line = vim.fn.getline(".")
    local match = string.match(line, "%[.-%]%((.-)%)")
    if match then
        -- get the directory of the current file
        local current_file_dir = vim.fn.expand("%:p:h")
        -- resolve the relative path to an absolute path
        local absolute_path = vim.fn.fnamemodify(current_file_dir .. "/" .. match, ":p")
        vim.cmd("edit " .. vim.fn.fnameescape(absolute_path))
    else
        print("no link under cursor")
    end
end, { desc = "open relative file links, similar to 'gx'" })

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

-- turn search highlighting off
map(
    "n",
    "<leader>h",
    ":nohlsearch<CR>",
    helpers.combine_tables(default_options, { desc = "turn off vim search highlights" })
)

-- make "x" not copy text
map("n", "x", '"_x', helpers.combine_tables(default_options, { desc = "make 'x' not copy text" }))

-- keep selection selected after > and <
map("v", ">", ">gv", helpers.combine_tables(default_options, { desc = "keep selection selected after >" }))
map("v", "<", "<gv", helpers.combine_tables(default_options, { desc = "keep selection selected after <" }))
