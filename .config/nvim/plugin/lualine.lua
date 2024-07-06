-- https://github.com/nvim-lualine/lualine.nvim
require("lualine").setup({

	options = {
		-- themes: https://github.com/nvim-lualine/lualine.nvim/blob/master/THEMES.md
		theme = "auto",
		-- disabled_filetypes = { "packer", "NvimTree" },
	},
	globalstatus = true,
})

-- always show the status bar and only show ONE status bar
-- source: https://neovim.io/doc/user/options.html#'laststatus'
-- i don't think this would be needed if globalstatus config played well with alpha dashboard
-- but it doesn't so this is a workaround that seems to be unintrusive
vim.o.laststatus = 3
