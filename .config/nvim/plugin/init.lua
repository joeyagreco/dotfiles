-- set up packer for plugin management
-- https://github.com/wbthomason/packer.nvim
require("packer").startup(function(use)
	use("wbthomason/packer.nvim")
	-- nvim-tree
	use("nvim-tree/nvim-web-devicons")
	use({
		"nvim-tree/nvim-tree.lua",
		requires = {
			"nvim-tree/nvim-web-devicons",
		},
	})

	-- telescope
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		requires = { "nvim-lua/plenary.nvim" },
	})

	-- treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
	})
	-- neoformat (format code)
	-- https://github.com/sbdchd/neoformat
	use("sbdchd/neoformat")
	-- LSP servers
	use("neovim/nvim-lspconfig")
	-- theme
	use("Abstract-IDE/Abstract-cs")
	use("marko-cerovac/material.nvim")
	-- git blame
	use("f-person/git-blame.nvim")
end)
