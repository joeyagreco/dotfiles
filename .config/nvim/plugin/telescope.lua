local actions = require("telescope.actions")
require("telescope").setup{
  defaults = {
	file_ignore_patterns = {},
	hidden = true,
    mappings = {
      i = {
        ["<esc>"] = actions.close
      },
    },
  }
}
