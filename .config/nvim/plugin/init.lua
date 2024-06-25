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
	-- COQ: https://github.com/ms-jpq/coq_nvim
	-- may need to run :COQdeps and :COQnow before this works
	use({
		"neovim/nvim-lspconfig",
		requires = { { "ms-jpq/coq_nvim", branch = "coq" }, { "ms-jpq/coq.artifacts", branch = "artifacts" } },
		init = function()
			vim.g.coq_settings = {
				auto_start = true, -- if you want to start COQ at startup
				-- Your COQ settings here
			}
		end,
	})
	-- theme
	use("Abstract-IDE/Abstract-cs")
	use("marko-cerovac/material.nvim")
	-- git blame
	use("f-person/git-blame.nvim")
	-- harpoon
	use({
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		requires = { { "nvim-lua/plenary.nvim" } },
	})
end)
