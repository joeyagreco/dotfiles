local constants = require("constants")

local M = {}

function M.prompt_and_open_git_repo()
	local path = vim.fn.input("Path: ", constants.LOCAL_GIT_REPO_PATH .. "/")
	vim.cmd("NvimTreeClose")
	vim.cmd("NvimTreeOpen " .. vim.fn.fnameescape(path))
end

return M
