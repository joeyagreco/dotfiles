-- https://github.com/sbdchd/neoformat
-- this is needed because by default, neoformat stops after a formatter succeeds
vim.g.neoformat_run_all_formatters = 1
vim.g.neoformat_enabled_sh = { "shfmt" }
vim.g.neoformat_enabled_zsh = { "shfmt" }
vim.g.neoformat_enabled_go = { "gofmt", "goimports" }
vim.g.neoformat_enabled_yaml = { "prettier" }
vim.g.neoformat_enabled_yml = { "prettier" }

-- proto format
-- https://clang.llvm.org/docs/ClangFormat.html
-- THIS ISNT WORKING RIGHT NOW WITH LINE LENGTH SET
vim.g.neoformat_enabled_proto = { "clang-format" }
vim.g.neoformat_cpp_clangformat = {
	exe = "clang-format",
	args = { "--style={ColumnLimit: 200}" },
	stdin = true,
}

-- Auto format on save using Neoformat
vim.cmd([[
  augroup fmt
    autocmd!
    autocmd BufWritePre * undojoin | Neoformat
  augroup END
]])
