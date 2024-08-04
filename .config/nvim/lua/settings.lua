-- auto compile plugins when plugin file is modified
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost */plugin/*.lua source <afile> | PackerCompile
  augroup end
]])

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
