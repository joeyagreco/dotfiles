-- https://github.com/sbdchd/neoformat
-- this is needed because by default, neoformat stops after a formatter succeeds
vim.g.neoformat_run_all_formatters = 1

-----------------------
-- custom formatters --
-----------------------
-- proto
vim.g.neoformat_proto_buf = {
	exe = "buf",
	args = { "format", "--write" },
	replace = 1, -- Overwrite the file directly
}

vim.g.neoformat_enabled_sh = { "shfmt" }
vim.g.neoformat_enabled_zsh = { "shfmt" }
vim.g.neoformat_enabled_go = { "gofmt", "goimports" }
vim.g.neoformat_enabled_yaml = { "prettier" }
vim.g.neoformat_enabled_yml = { "prettier" }
vim.g.neoformat_enabled_py = { "black", "isort" }
vim.g.neoformat_enabled_proto = { "buf" }

-- Auto format on save using Neoformat
vim.cmd([[
  augroup fmt
    autocmd!
    autocmd BufWritePre * undojoin | Neoformat
  augroup END
]])
