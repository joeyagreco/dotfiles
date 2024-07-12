vim.g.neoformat_enabled_sh = { "shfmt" }
vim.g.neoformat_enabled_zsh = { "shfmt" }
vim.g.neoformat_enabled_go = { "gofmt" }

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
