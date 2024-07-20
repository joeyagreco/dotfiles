require("nvim-treesitter.configs").setup({
	ensure_installed = { "go", "python", "typescript", "javascript" },
	highlight = {
		enable = true,
	},
	indent = {
		enable = true,
	},
})
