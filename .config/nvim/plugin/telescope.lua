local actions = require("telescope.actions")
local telescope = require("telescope")

telescope.setup({
	defaults = {
		path_display = { "smart" },
		file_ignore_patterns = {
			"build/",
			"dist/",
			"node_modules/",
			".git/",
		},
		hidden = true,
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--ignore-case",
			"--fixed-strings",
			"--hidden", -- Include hidden files
		},
		mappings = {
			i = {
				["<esc>"] = actions.close,
			},
		},
	},
	pickers = {
		find_files = {
			hidden = true,
		},
	},
})

-- this must be last
telescope.load_extension("live_grep_args")
