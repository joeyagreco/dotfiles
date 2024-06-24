require("nvim-tree").setup({
	sort = {
		sorter = "case_sensitive",
	},
	view = {
		width = 40,
	},
	renderer = {
		group_empty = true,
	},
	filters = {
		dotfiles = false,
	},
})
