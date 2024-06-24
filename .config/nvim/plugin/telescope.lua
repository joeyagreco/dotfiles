local actions = require("telescope.actions")
require("telescope").setup({
	defaults = {
		file_ignore_patterns = {},
		hidden = true,
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
		},
		mappings = {
			i = {
				["<esc>"] = actions.close,
			},
		},
	},
})
