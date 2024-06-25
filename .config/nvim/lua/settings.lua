local constants = require("constants")

-- Auto format on save using Neoformat
vim.cmd([[
  augroup fmt
    autocmd!
    autocmd BufWritePre * undojoin | Neoformat
  augroup END
]])

-- use system clipboard
vim.o.clipboard = "unnamedplus"

-- set python to use
vim.g.python3_host_prog = constants.PYTHON_PATH
