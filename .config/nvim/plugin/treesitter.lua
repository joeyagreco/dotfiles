require("nvim-treesitter.configs").setup({
	ensure_installed = { "go", "python", "typescript" },
	highlight = {
		enable = true,
	},
	indent = {
		enable = true,
	},
})
