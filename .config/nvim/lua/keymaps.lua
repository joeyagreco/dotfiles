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

map("n", "<leader>S", function()
    local word = vim.fn.expand("<cword>") -- get the word under the cursor
    vim.fn.setreg("/", word) -- store the word in the search register
    vim.cmd("set hlsearch") -- enable search highlighting to show matches
end, helpers.combine_tables(default_options, { desc = "start a search for word under cursor" }))

---------
-- LSP --
---------

-- get lsp info for whatever the cursor is on
map("n", "K", function()
    vim.lsp.buf.hover({ border = "rounded" })
end, helpers.combine_tables(default_options, { desc = "see lsp info for word under cursor" }))

-- see lsp info
map("n", "<leader>L", function()
    vim.diagnostic.open_float(nil, { source = "always", focusable = true, border = "rounded" })
end, helpers.combine_tables(default_options, { desc = "see lsp info with source" }))

-- open file references like @path/to/file.py or @path/to/file.py#L123
vim.keymap.set("n", "gX", function()
    local line = vim.fn.getline(".")
    -- match @path/to/file with optional #L123
    local path, line_num = string.match(line, "@([^@%s#]+)#L(%d+)")
    if not path then
        path = string.match(line, "@([^@%s#]+)")
    end
    if path then
        -- get git root directory
        local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
        if vim.v.shell_error ~= 0 then
            print("not in a git repository")
            return
        end
        local absolute_path = git_root .. "/" .. path
        vim.cmd("edit " .. vim.fn.fnameescape(absolute_path))
        if line_num then
            vim.cmd(":" .. line_num)
        end
    else
        print("no @path reference found on line")
    end
end, { desc = "open file reference like @path/to/file.py#L123" })

-------------
-- GENERAL --
-------------

-- quit vim
map("n", "<leader>q", ":qa<CR>", helpers.combine_tables(default_options, { desc = "exit vim" }))

-- disable space in normal and visual mode
map(
    { "n", "v" },
    "<Space>",
    "<Nop>",
    helpers.combine_tables(default_options, { desc = "disabled space in normal and visual mode" })
)

-- redo
map("n", "U", "<C-r>", helpers.combine_tables(default_options, { desc = "redo" }))

-- close things
--  - tabs
--  - quickfix lists
map("n", "<leader>t", function()
    if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
        vim.cmd("cclose")
    end
    if #vim.api.nvim_list_tabpages() > 1 then
        vim.cmd("tabclose")
    end
end, helpers.combine_tables(default_options, { desc = "close things" }))

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

-- move selected text up and down
map("v", "J", ":m '>+1<CR>gv=gv", helpers.combine_tables(default_options, { desc = "move selected text down" }))
map("v", "K", ":m '<-2<CR>gv=gv", helpers.combine_tables(default_options, { desc = "move selected text up" }))

-- toggle comments
map("n", "<leader>/", "gcc", helpers.combine_tables({ remap = true }, { desc = "toggle comment (line)" }))
map("x", "<leader>/", "gc", helpers.combine_tables({ remap = true }, { desc = "toggle comment (visual)" }))
