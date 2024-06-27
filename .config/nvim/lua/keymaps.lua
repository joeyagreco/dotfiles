-- import apis
local telescope = require("telescope.builtin")
local nvim_tree = require("nvim-tree.api")
-- local harpoon = require("harpoon")
local helpers = require("helpers")

-- keep track of custom keymaps by letter to prevent collision delay
-- a
-- c
-- e
-- ff
-- fh
-- fm
-- fs
-- fw
-- gd
-- gu
-- ho
-- K
-- m
-- pp
-- R
-- rn
-- /

-- Set leader to SPACE
vim.g.mapleader = " "

-- toggle on / focus on explorer (<LEADER>e)
vim.keymap.set("n", "<leader>e", function()
	nvim_tree.tree.open({ focus = true })
end, { noremap = true, silent = true, desc = "open / focus explorer" })

-- format code (<LEADER>fm)
vim.api.nvim_set_keymap("n", "<leader>fm", ":Neoformat<cr>", { noremap = true, silent = true, desc = "format code" })

-- search for word that cursor is on (<LEADER>fw)
vim.keymap.set("n", "<leader>fw", function()
	telescope.grep_string({
		word_match = "-w",
		search = vim.fn.expand("<cword>"),
		cwd = vim.fn.getcwd(),
	})
end, { noremap = true, silent = true, desc = "search for word under cursor" })

-- serach for a word (<LEADER>fs)
vim.keymap.set("n", "<leader>fs", function()
	require("telescope.builtin").live_grep({})
end, { noremap = true, silent = true, desc = "open popup to search for words case insensitively" })

-- find files (<LEADER>ff)
vim.keymap.set("n", "<leader>ff", function()
	require("telescope.builtin").find_files({})
end, { noremap = true, silent = true, desc = "find files" })

-- find files including hidden (<LEADER>fh)
vim.keymap.set("n", "<leader>fh", function()
	require("telescope.builtin").find_files({
		hidden = true,
		file_ignore_patterns = { "node_modules", "build", "dist", "yarn.lock", ".git" },
	})
end, { noremap = true, silent = true, desc = "find files including hidden" })

-- go to definition for whatever the cursor is on (<LEADER>gd)
vim.keymap.set(
	"n",
	"<leader>gd",
	vim.lsp.buf.definition,
	{ noremap = true, silent = true, desc = "go to definition for whatever the cursor is on" }
)

-- rename symbol
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { noremap = true, silent = true, desc = "Rename Symbol" })

-- toggle tree (<LEADER>t)
vim.keymap.set("n", "<leader>t", function()
	nvim_tree.tree.toggle()
end, { noremap = true, silent = true, desc = "toggle tree" })

-- -- add to harpoon menu (<LEADER>a)
-- vim.keymap.set("n", "<leader>a", function()
-- 	harpoon:list():add()
-- end, { noremap = true, silent = true, desc = "add current file to harpoon menu" })
--
-- -- open harpoon menu (<LEADER>m)
-- vim.keymap.set("n", "<leader>m", function()
-- 	harpoon.ui:toggle_quick_menu(harpoon:list())
-- end, { noremap = true, silent = true, desc = "open harpoon menu" })
--
-- -- clear harpoon menu (<LEADER>c)
-- vim.keymap.set("n", "<leader>c", function()
-- 	harpoon:list():clear()
-- end, { noremap = true, silent = true, desc = "clear harpoon menu" })
--
-- -- Toggle previous & next buffers stored within Harpoon list
-- -- (<CTRL>p) (<CTRL>n)
-- vim.keymap.set("n", "<C-P>", function()
-- 	harpoon:list():prev()
-- end, { noremap = true, silent = true, desc = "prev harpoon buffer" })
--
-- vim.keymap.set("n", "<C-N>", function()
-- 	harpoon:list():next()
-- end, { noremap = true, silent = true, desc = "next harpoon buffer" })

-- 'if __name__ == "__main__"' (<LEADER>inm)
vim.keymap.set(
	"n",
	"<leader>inm",
	'iif __name__ == "__main__":<Esc>o',
	{ noremap = true, silent = true, desc = "if name == main " }
)

-- get lsp info for whatever the cursor is on (K)
vim.keymap.set("n", "K", vim.lsp.buf.hover, { noremap = true, silent = true, desc = "Show info popup over function" })

-- turn search highlighting off (<LEADER>ho)
vim.keymap.set(
	"n",
	"<leader>ho",
	":nohlsearch<CR>",
	{ noremap = true, silent = true, desc = "turn off vim search highlights" }
)

-- open a git directory
vim.keymap.set(
	"n",
	"<leader>gi",
	helpers.prompt_and_open_git_repo,
	{ noremap = true, silent = true, desc = "open a git dir" }
)

-- quit vim (<LEADER>qq)
vim.keymap.set("n", "<leader>qq", ":qa<CR>", { noremap = true, silent = true, desc = "exit vim" })

-- copy url of current line in git
vim.keymap.set("n", "<leader>gu", function()
	vim.cmd("GitBlameCopyFileURL")
	print("git url copied")
end, { noremap = true, silent = true, desc = "copy url of current line in git" })

-- toggle recent files
vim.keymap.set(
	"n",
	"<leader>R",
	":Telescope oldfiles<CR>",
	{ noremap = true, silent = true, desc = "toggle recent files" }
)

-- comment out / uncomment line and selection (<LEADER>/)
vim.keymap.set("n", "<leader>/", function()
	require("Comment.api").toggle.linewise.current()
end, { noremap = true, silent = true, desc = "Comment current line" })

vim.keymap.set(
	"v",
	"<leader>/",
	'<ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>',
	{ noremap = true, silent = true, desc = "Comment selection" }
)

-- clean and update plugins (<LEADER>pp)
vim.keymap.set(
	"n",
	"<leader>pp",
	helpers.clean_and_update_plugins,
	{ noremap = true, silent = true, desc = "clean and update plugins" }
)
