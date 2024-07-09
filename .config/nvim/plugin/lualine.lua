local lualine = require("lualine")
-- https://github.com/nvim-lualine/lualine.nvim
lualine.setup({
	options = {
		-- themes: https://github.com/nvim-lualine/lualine.nvim/blob/master/THEMES.md
		theme = "auto",
		-- disabled_filetypes = { "packer", "NvimTree" },
	},
	-- not sure i prefer this to just disabling lualine when nvimtree is focused
	extensions = { "nvim-tree" },
	globalstatus = true,
	sections = {
		lualine_a = { { "mode", padding = 2 } },
		lualine_c = {
			{
				"filename",
				-- 0: Just the filename
				-- 1: Relative path
				-- 2: Absolute path
				-- 3: Absolute path, with tilde as the home directory
				-- 4: Filename and parent dir, with tilde as the home directory
				path = 1,
				symbols = {
					modified = "[ + ]", -- Text to show when the file is modified.
					readonly = "[ - ]", -- Text to show when the file is non-modifiable or readonly.
					unnamed = "[ unnamed ]", -- Text to show for unnamed buffers.
					newfile = "[ new ]", -- Text to show for newly created file before first write
				},
			},
		},
		lualine_x = { "filetype" },
		lualine_y = {},
		lualine_z = {
			{
				"datetime",
				style = "%A, %B %-d | %-I:%M %p",
			},
		},
	},
})

-- always show the status bar and only show ONE status bar
-- source: https://neovim.io/doc/user/options.html#'laststatus'
-- i don't think this would be needed if globalstatus config played well with alpha dashboard
-- but it doesn't so this is a workaround that seems to be unintrusive
vim.o.laststatus = 3

-- refresh lualine whenever the buffer is focused
-- this ensures git dif is up to date
vim.api.nvim_create_autocmd("FocusGained", {
	callback = lualine.refresh,
	desc = "Refresh lualine when Neovim gains focus",
})

vim.api.nvim_create_autocmd("BufEnter", {
	callback = lualine.refresh,
	desc = "Refresh lualine when buffer is focused",
})
