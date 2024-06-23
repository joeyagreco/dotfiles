require('telescope').setup{
	defaults = {
	  file_ignore_patterns = {},
	  hidden = true
	}
  }

local actions = require("telescope.actions")
require("telescope").setup{
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close
      },
    },
  }
}
