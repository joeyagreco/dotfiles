-- idk if this is needed anymore
-- -- close quickfix automatically when navigated off of it
-- vim.api.nvim_create_autocmd("CursorMoved", {
-- 	callback = function()
-- 		if vim.fn.getwininfo(vim.fn.win_getid())[1].quickfix == 1 then
-- 			vim.cmd("cclose")
-- 		end
-- 	end,
-- })

-- auto compile plugins when plugin file is modified
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost */plugin/*.lua source <afile> | PackerCompile
  augroup end
]])

-- vim.api.nvim_create_augroup("remember_folds", {})
--
-- vim.api.nvim_create_autocmd({ "BufWinLeave", "BufWritePost", "InsertLeave" }, {
-- 	group = "remember_folds",
-- 	pattern = "*.*",
-- 	desc = "save view (folds) when closing, writing file, or leaving insert mode",
-- 	command = "silent! mkview",
-- })
--
-- vim.api.nvim_create_autocmd("BufWinEnter", {
-- 	group = "remember_folds",
-- 	pattern = "*.*",
-- 	desc = "load view (folds) when opening file",
-- 	command = "silent! loadview",
-- })
--

-- Define the custom filetype for files that start with "requirements" and end with ".txt"
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "requirements*.txt",
	callback = function()
		vim.bo.filetype = "requirements"
	end,
	desc = "Set filetype to requirements for files matching requirements*.txt",
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.yamlfmt",
	callback = function()
		vim.bo.filetype = "yaml"
	end,
	desc = "Set filetype to yaml for .yamlfmt files",
})
