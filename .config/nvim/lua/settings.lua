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

-- autocommand to run actionlint on save for YAML files
vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = { "*.yaml", "*.yml" },
	callback = function()
		vim.cmd("!actionlint %")
	end,
	desc = "run actionlint on save for YAML files",
})
