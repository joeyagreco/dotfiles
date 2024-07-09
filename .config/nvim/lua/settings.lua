local lualine = require("lualine")

-- Auto format on save using Neoformat
vim.cmd([[
  augroup fmt
    autocmd!
    autocmd BufWritePre * undojoin | Neoformat
  augroup END
]])

-- auto compile plugins when plugin file is modified
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost */plugin/*.lua source <afile> | PackerCompile
  augroup end
]])

-- Auto-close Alpha buffer when opening a file
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	callback = function()
		if vim.bo.filetype ~= "alpha" and vim.fn.bufname() ~= "" and #vim.fn.getbufinfo({ buflisted = 1 }) > 1 then
			for _, buf in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
				if buf.name:match("alpha") then
					vim.cmd("bdelete " .. buf.bufnr)
				end
			end
		end
	end,
})

-- close quickfix automatically when navigated off of it
vim.api.nvim_create_autocmd("CursorMoved", {
	callback = function()
		if vim.fn.getwininfo(vim.fn.win_getid())[1].quickfix == 1 then
			vim.cmd("cclose")
		end
	end,
})

-- refresh lualine whenever the buffer is focused
-- this ensures git dif is up to date

vim.api.nvim_create_autocmd("FocusGained", {
	callback = lualine.refresh,
	desc = "Refresh lualine when Neovim gains focus",
})

vim.api.nvim_create_autocmd("BufEnter", {
	callback = lualine.refresh,
	desc = "Refresh lualine when buffer is focused",
})
