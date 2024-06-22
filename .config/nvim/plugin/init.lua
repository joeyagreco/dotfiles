-- set up packer for plugin management
require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'
	-- nvim-tree
	use 'nvim-tree/nvim-web-devicons'
	use {
		'nvim-tree/nvim-tree.lua',
		requires = {
			'nvim-tree/nvim-web-devicons', -- optional
		 },
	 }
end)

require('nvim-web-devicons').setup() 
require('nvim-tree').setup()
