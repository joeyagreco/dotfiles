local constants = require("constants")

local M = {}

function M.prompt_and_open_git_repo()
	local path = vim.fn.input("Path: ", constants.LOCAL_GIT_REPO_PATH .. "/")
	vim.cmd("cd " .. vim.fn.fnameescape(path))
	vim.cmd("NvimTreeOpen")
end

function M.clean_and_update_plugins()
	vim.cmd("PackerClean")
	vim.cmd("PackerUpdate")
end

return M
