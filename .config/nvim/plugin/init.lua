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
  end)
  
  -- setup nvim-web-devicons
  require('nvim-web-devicons').setup()
  
  -- setup nvim-tree
  require("nvim-tree").setup({
	sort = {
	  sorter = "case_sensitive"
	},
	view = {
	  width = 50,
	},
	renderer = {
	  group_empty = true,
	},
	filters = {
	  dotfiles = false,
	},
  })
  
  -- setup telescope
  require('telescope').setup{
	defaults = {
	  file_ignore_patterns = {},
	  hidden = true
	}
  }
  
  -- setup nvim-treesitter
  require'nvim-treesitter.configs'.setup {
	-- ensure_installed = "all", -- only list parsers that are needed
	highlight = {
	  enable = true,
	},
  }
  