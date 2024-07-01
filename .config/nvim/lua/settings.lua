local constants = require("constants")

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

-- use system clipboard
vim.o.clipboard = "unnamedplus"

-- set python to use
vim.g.python3_host_prog = constants.PYTHON_PATH

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

-- disable netrw for nvim-tree
-- :help nvim-tree-netrw
-- https://github.com/nvim-tree/nvim-tree.lua?tab=readme-ov-file#install
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- fold config
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99
