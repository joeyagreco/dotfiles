-- https://github.com/nvim-tree/nvim-tree.lua/blob/12a9a995a455d2c2466e47140663275365a5d2fc/doc/nvim-tree-lua.txt#L376
local constants = require("constants")

-- set sort.sorter to this func for custom sorting
-- local custom_sorter = function(nodes)
-- 	table.sort(nodes, function(a, b)
-- 		return #a.name > #b.name
-- 	end)
-- end

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
		update_cwd = true,
		update_root = true,
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
	filters = {
		enable = true,
		git_ignored = true,
		dotfiles = false,
		git_clean = false,
		no_buffer = false,
		no_bookmark = false,
	},
})
