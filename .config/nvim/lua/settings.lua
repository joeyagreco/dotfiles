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
