local telescope_builtin = require("telescope.builtin")
local telescope = require("telescope")
local nvim_tree = require("nvim-tree.api")
local git_signs = require("gitsigns")
local comment = require("Comment.api")
local helpers = require("helpers")

-- keep track of custom keymaps by letter to prevent collision delay
-- c
-- cn
-- dif
-- e
-- E
-- ff
-- fm
-- fr
-- fs
-- fw
-- gd
-- gi
-- gp
-- gr
-- gR
-- gu
-- ho
-- i
-- K
-- l
-- L
-- p
-- qq
-- r
-- R
-- /

-- Set leader to SPACE
vim.g.mapleader = " "

local default_options = { noremap = true, silent = true }
local map = vim.keymap.set

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

-- format code
map("n", "<leader>fm", ":Neoformat<cr>", helpers.combine_tables(default_options, { desc = "format code" }))

-- search for word that cursor is on
map("n", "<leader>fw", function()
	telescope_builtin.grep_string({
		word_match = "-w",
		search = vim.fn.expand("<cword>"),
		cwd = vim.fn.getcwd(),
	})
end, helpers.combine_tables(default_options, { desc = "search for word under cursor" }))

-- search for a word
-- https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md
map(
	"n",
	"<leader>fs",
	telescope.extensions.live_grep_args.live_grep_args,
	helpers.combine_tables(default_options, { desc = "search for words" })
)

-- find files
map("n", "<leader>ff", function()
	telescope_builtin.find_files({
		hidden = true,
		file_ignore_patterns = { "node_modules", "build", "dist", "yarn.lock", ".git" },
	})
end, helpers.combine_tables(default_options, { desc = "find files" }))

-- go to definition for whatever the cursor is on
map(
	"n",
	"<leader>gd",
	vim.lsp.buf.definition,
	helpers.combine_tables(default_options, { desc = "go to definition for word under cursor" })
)

-- get lsp info for whatever the cursor is on
map(
	"n",
	"K",
	vim.lsp.buf.hover,
	helpers.combine_tables(default_options, { desc = "see lsp info for word under cursor" })
)

-- find references for whatever cursor is on
map(
	"n",
	"<leader>fr",
	telescope_builtin.lsp_references,
	helpers.combine_tables(default_options, { desc = "find references" })
)

-- find old (open up telescope search with previous search)
map(
	"n",
	"<leader>fo",
	telescope_builtin.resume,
	helpers.combine_tables(default_options, { desc = "resume previous search" })
)

-- 'if __name__ == "__main__"'
map(
	"n",
	"<leader>inm",
	'iif __name__ == "__main__":<Esc>o',
	helpers.combine_tables(default_options, { desc = "if name == main" })
)

-- rename symbol (change name)
map("n", "<leader>cn", vim.lsp.buf.rename, helpers.combine_tables(default_options, { desc = "rename symbol" }))

-- turn search highlighting off
map(
	"n",
	"<leader>ho",
	":nohlsearch<CR>",
	helpers.combine_tables(default_options, { desc = "turn off vim search highlights" })
)

-- open a git directory
map(
	"n",
	"<leader>gi",
	helpers.prompt_and_open_git_repo,
	helpers.combine_tables(default_options, { desc = "open a git directory" })
)

-- quit vim
map("n", "<leader>qq", ":qa<CR>", helpers.combine_tables(default_options, { desc = "exit vim" }))

-- copy url of current line in git
map("n", "<leader>gu", function()
	vim.cmd("GitBlameCopyFileURL")
	print("git url copied")
end, helpers.combine_tables(default_options, { desc = "copy url of current line in git" }))

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

-- toggle recent files scoped to this directory
map("n", "<leader>r", function()
	telescope_builtin.oldfiles({ cwd = vim.fn.getcwd() })
end, helpers.combine_tables(default_options, { desc = "see recent files" }))

-- toggle recent files with no scope (show all recent files)
map("n", "<leader>R", function()
	telescope_builtin.oldfiles()
end, helpers.combine_tables(default_options, { desc = "see recent files" }))

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

-- clean and update plugins
map(
	"n",
	"<leader>p",
	helpers.clean_and_update_plugins,
	helpers.combine_tables(default_options, { desc = "clean and update plugins" })
)

-- open git diff view
map("n", "<leader>dif", ":DiffviewOpen<CR>", helpers.combine_tables(default_options, { desc = "open git dif view" }))

-- close tab
map("n", "<leader>c", ":tabc<CR>", helpers.combine_tables(default_options, { desc = "close tab" }))

-- go to last buffer
map("n", "<leader>l", "<C-^>", helpers.combine_tables(default_options, { desc = "go to last buffer" }))

-- auto import
map("n", "<leader>i", function()
	vim.lsp.buf.code_action({ source = { organizeImports = true } })
end, helpers.combine_tables(default_options, { desc = "go to last buffer" }))

-- see lsp info
map("n", "<leader>L", vim.diagnostic.open_float, helpers.combine_tables(default_options, { desc = "see lsp info" }))
