-- set up packer for plugin management
require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'
	
	-- nvim-tree
	use 'nvim-tree/nvim-web-devicons'
	use {
	  'nvim-tree/nvim-tree.lua',
	  requires = {
		'nvim-tree/nvim-web-devicons',
	  },
	}
  
	-- telescope
	use { 
	  'nvim-telescope/telescope.nvim',
	  tag = '0.1.8',
	  requires = { 'nvim-lua/plenary.nvim' }
	}
	
	-- treesitter
	use {
	  'nvim-treesitter/nvim-treesitter',
	  run = function()
		local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
		ts_update()
	  end,
	}
	-- neoformat
	-- https://github.com/sbdchd/neoformat
	use 'sbdchd/neoformat' 
	-- theme
	use 'Abstract-IDE/Abstract-cs'
        use 'marko-cerovac/material.nvim'
end)


require("plugin/nvim_tree")
require("plugin/nvim_web_devicons")
require("plugin/telescope")
require("plugin/treesitter")


 



  
