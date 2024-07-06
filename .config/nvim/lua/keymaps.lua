local telescope_builtin = require("telescope.builtin")
local telescope = require("telescope")
local nvim_tree = require("nvim-tree.api")
local git_signs = require("gitsigns")
local comment = require("Comment.api")
local helpers = require("helpers")

-- keep track of custom keymaps by letter to prevent collision delay
-- c
-- dif
-- e
-- ff
-- fm
-- fr
-- fs
-- fw
-- gd
-- gp
-- gr
-- gR
-- gu
-- ho
-- i
-- K
-- l
-- L
-- m
-- pp
-- R
-- rn
-- /

-- Set leader to SPACE
vim.g.mapleader = " "

local default_options = { noremap = true, silent = true }
local keyset = vim.keymap.set

-- toggle on / focus on explorer (<LEADER>e)
keyset("n", "<leader>e", function()
	nvim_tree.tree.open({ focus = true })
end, helpers.combine_tables(default_options, { desc = "open / focus explorer" }))

-- format code (<LEADER>fm)
keyset("n", "<leader>fm", ":Neoformat<cr>", helpers.combine_tables(default_options, { desc = "format code" }))

-- search for word that cursor is on (<LEADER>fw)
keyset("n", "<leader>fw", function()
	telescope_builtin.grep_string({
		word_match = "-w",
		search = vim.fn.expand("<cword>"),
		cwd = vim.fn.getcwd(),
	})
end, helpers.combine_tables(default_options, { desc = "search for word under cursor" }))

-- search for a word (<LEADER>fs)
-- https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md
keyset(
	"n",
	"<leader>fs",
	telescope.extensions.live_grep_args.live_grep_args,
	helpers.combine_tables(default_options, { desc = "search for words" })
)

-- find files (<LEADER>ff)
keyset("n", "<leader>ff", function()
	telescope_builtin.find_files({
		hidden = true,
		file_ignore_patterns = { "node_modules", "build", "dist", "yarn.lock", ".git" },
	})
end, helpers.combine_tables(default_options, { desc = "find files" }))

-- go to definition for whatever the cursor is on (<LEADER>gd)
keyset(
	"n",
	"<leader>gd",
	vim.lsp.buf.definition,
	helpers.combine_tables(default_options, { desc = "go to definition for word under cursor" })
)

-- get lsp info for whatever the cursor is on (K)
keyset(
	"n",
	"K",
	vim.lsp.buf.hover,
	helpers.combine_tables(default_options, { desc = "see lsp info for word under cursor" })
)

-- find references for whatever cursor is on
keyset(
	"n",
	"<leader>fr",
	telescope_builtin.lsp_references,
	helpers.combine_tables(default_options, { desc = "find references" })
)

-- find old (open up telescope search with previous search)
keyset(
	"n",
	"<leader>fo",
	telescope_builtin.resume,
	helpers.combine_tables(default_options, { desc = "resume previous search" })
)

-- 'if __name__ == "__main__"' (<LEADER>inm)
keyset(
	"n",
	"<leader>inm",
	'iif __name__ == "__main__":<Esc>o',
	helpers.combine_tables(default_options, { desc = "if name == main" })
)

-- rename symbol
keyset("n", "<leader>rn", vim.lsp.buf.rename, helpers.combine_tables(default_options, { desc = "rename symbol" }))

-- toggle tree (<LEADER>t)
keyset("n", "<leader>t", nvim_tree.tree.toggle, helpers.combine_tables(default_options, { desc = "toggle tree" }))

-- turn search highlighting off (<LEADER>ho)
keyset(
	"n",
	"<leader>ho",
	":nohlsearch<CR>",
	helpers.combine_tables(default_options, { desc = "turn off vim search highlights" })
)

-- open a git directory
keyset(
	"n",
	"<leader>gi",
	helpers.prompt_and_open_git_repo,
	helpers.combine_tables(default_options, { desc = "open a git directory" })
)

-- quit vim (<LEADER>qq)
keyset("n", "<leader>qq", ":qa<CR>", helpers.combine_tables(default_options, { desc = "exit vim" }))

-- copy url of current line in git
keyset("n", "<leader>gu", function()
	vim.cmd("GitBlameCopyFileURL")
	print("git url copied")
end, helpers.combine_tables(default_options, { desc = "copy url of current line in git" }))

-- reset current cursor hunk
keyset(
	"n",
	"<leader>gr",
	git_signs.reset_hunk,
	helpers.combine_tables(default_options, { desc = "git reset current hunk" })
)

-- reset all hunks in current file/buffer
keyset(
	"n",
	"<leader>gR",
	git_signs.reset_buffer,
	helpers.combine_tables(default_options, { desc = "git reset current buffer" })
)

-- preview current cursor hunk
keyset(
	"n",
	"<leader>gp",
	git_signs.preview_hunk,
	helpers.combine_tables(default_options, { desc = "git preview current hunk" })
)

-- toggle recent files
keyset(
	"n",
	"<leader>R",
	":Telescope oldfiles<CR>",
	helpers.combine_tables(default_options, { desc = "see recent files" })
)

-- comment out / uncomment line and selection (<LEADER>/)
keyset(
	"n",
	"<leader>/",
	comment.toggle.linewise.current,
	helpers.combine_tables(default_options, { desc = "comment current line" })
)

keyset(
	"v",
	"<leader>/",
	'<ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>',
	helpers.combine_tables(default_options, { desc = "comment current selection" })
)

-- clean and update plugins (<LEADER>pp)
keyset(
	"n",
	"<leader>pp",
	helpers.clean_and_update_plugins,
	helpers.combine_tables(default_options, { desc = "clean and update plugins" })
)

-- open git diff view
keyset("n", "<leader>dif", ":DiffviewOpen<CR>", helpers.combine_tables(default_options, { desc = "open git dif view" }))

-- close tab
keyset("n", "<leader>c", ":tabc<CR>", helpers.combine_tables(default_options, { desc = "close tab" }))

-- go to last buffer
keyset("n", "<leader>l", "<C-^>", helpers.combine_tables(default_options, { desc = "go to last buffer" }))

-- auto import
keyset("n", "<leader>i", function()
	vim.lsp.buf.code_action({ source = { organizeImports = true } })
end, helpers.combine_tables(default_options, { desc = "go to last buffer" }))

-- see lsp info
keyset("n", "<leader>L", vim.diagnostic.open_float, helpers.combine_tables(default_options, { desc = "see lsp info" }))

-- focus from nvim tree -> main buffer
keyset(
	"n",
	"<leader>m",
	":wincmd l<CR>",
	helpers.combine_tables(default_options, { desc = "focus from nvim tree -> main buffer" })
)
