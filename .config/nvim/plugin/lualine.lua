-- https://github.com/nvim-lualine/lualine.nvim
require("lualine").setup({
	options = {
		-- themes: https://github.com/nvim-lualine/lualine.nvim/blob/master/THEMES.md
		theme = "auto",
		-- disabled_filetypes = { "packer", "NvimTree" },
	},
	globalstatus = true,
	sections = {
		lualine_a = { { "mode", padding = 2 } },
		lualine_c = { { "filename", path = 0 } },
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
