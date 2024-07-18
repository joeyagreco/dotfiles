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

-- Remember folds when switching buffers or windows, and on write/format, ignoring errors
vim.api.nvim_create_augroup("remember_folds", {})
vim.api.nvim_create_autocmd({ "BufWinLeave", "BufWritePost" }, {
	group = "remember_folds",
	pattern = "*.*",
	desc = "save view (folds) when closing or writing file",
	command = "silent! mkview",
})
vim.api.nvim_create_autocmd("BufWinEnter", {
	group = "remember_folds",
	pattern = "*.*",
	desc = "load view (folds) when opening file",
	command = "silent! loadview",
})
