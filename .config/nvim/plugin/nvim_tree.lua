-- https://github.com/nvim-tree/nvim-tree.lua/blob/12a9a995a455d2c2466e47140663275365a5d2fc/doc/nvim-tree-lua.txt#L376
local constants = require("constants")
local nvim_tree = require("nvim-tree")

-- set sort.sorter to this func for custom sorting
-- local custom_sorter = function(nodes)
-- 	local cwd = vim.loop.cwd()
--
-- 	table.sort(nodes, function(a, b)
-- 		-- Then sort by name based on the current directory
-- 		if cwd == constants.NOTES_PATH then
-- 			-- for notes folder, we want to show reverse alphabetical order
-- 			-- this way, most recent notes are at the top
-- 			return a.name > b.name
-- 		else
-- 			return nvim_tree.explorer.sorters.case_sensitive(a, b, {})
-- 		end
-- 	end)
-- end

nvim_tree.setup({
	sort = {
		sorter = "case_sensitive",
		-- sorter = custom_sorter,
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
