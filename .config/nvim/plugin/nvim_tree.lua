local constants = require("constants")

-- config docs: https://github.com/nvim-tree/nvim-tree.lua/blob/master/doc/nvim-tree-lua.txt
require("nvim-tree").setup({
	sort = {
		sorter = "case_sensitive",
	},
	view = {
		width = 40,
	},
	renderer = {
		group_empty = true,
	},
	update_focused_file = {
		enable = true,
		update_root = {
			enable = true
		}
	},
	-- set all local git directories as root dirs
	root_dirs = constants.ALL_LOCAL_GIT_REPO_PATHS,
	-- auto update tree based on cwd
	-- this allows us to just change the cwd and see the tree update automatically
	hijack_directories = {
		enable = true,
		auto_open = true,
	},
	sync_root_with_cwd = true,
	respect_buf_cwd = true,
})
