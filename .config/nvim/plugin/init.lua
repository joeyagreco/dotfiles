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
		requires = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-live-grep-args.nvim" },
	})

	-- treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
	})
	-- neoformat
	-- https://github.com/sbdchd/neoformat
	use("sbdchd/neoformat")
	-- LSP servers
	-- COQ: https://github.com/ms-jpq/coq_nvim
	-- may need to run :COQdeps and :COQnow before this works
	use({
		"neovim/nvim-lspconfig",
		requires = { { "ms-jpq/coq_nvim", branch = "coq" }, { "ms-jpq/coq.artifacts", branch = "artifacts" } },
	})
	-- theme
	use("Abstract-IDE/Abstract-cs")
	use("marko-cerovac/material.nvim")
	-- git blame
	use("f-person/git-blame.nvim")
	-- dashboard
	use({
		"goolord/alpha-nvim",
		requires = { "nvim-tree/nvim-web-devicons" },
	})
	-- comment code
	use("numToStr/Comment.nvim")
	-- git signs
	use("lewis6991/gitsigns.nvim")
	-- git diff
	use("sindrets/diffview.nvim")
	-- autoclose
	use("m4xshen/autoclose.nvim")
end)
