local constants = require("constants")

local M = {}

function M.prompt_and_open_git_repo()
	local local_git_path = constants.LOCAL_GIT_REPO_PATH .. "/"
	local path = vim.fn.trim(vim.fn.input("Path: ", local_git_path))
	if path ~= local_git_path and path ~= "" then
		vim.cmd("cd " .. vim.fn.fnameescape(path))
		vim.cmd("NvimTreeOpen")
	end
end

function M.clean_and_update_plugins()
	vim.cmd("PackerClean")
	vim.cmd("PackerUpdate")
end

return M
