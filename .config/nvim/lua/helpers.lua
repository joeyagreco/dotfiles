local constants = require("constants")

local M = {}

function M.prompt_and_open_git_repo()
	local local_git_path = constants.LOCAL_GIT_REPO_PATH .. "/"
	local path = vim.fn.trim(vim.fn.input("Path: ", local_git_path))
	if path ~= local_git_path and path ~= "" then
		vim.cmd("cd " .. vim.fn.fnameescape(path))
		-- we close all file buffers here for this reason:
		-- 1. nvimtree in dir A
		-- 2. buffer has file open from dir A
		-- 3. switch git dir to dir B
		-- 4. nvimtree will NOT update to dir B until it is closed and opened again
		M.close_all_file_buffers()
		-- NOTE: we could also just do :NvimTreeClose and :NvimTreeOpen instead
	end
end

function M.clean_and_update_plugins()
	vim.cmd("PackerClean")
	vim.cmd("PackerUpdate")
end

function M.close_all_file_buffers()
	for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buffer) then
			local buftype = vim.api.nvim_buf_get_option(buffer, 'buftype')
			if buftype == '' then -- Only close normal file buffers
				vim.api.nvim_buf_delete(buffer, { force = true })
			end
		end
	end
end

return M
