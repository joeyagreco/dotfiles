vim.g.neoformat_enabled_sh = { "shfmt" }
vim.g.neoformat_enabled_zsh = { "shfmt" }

-- proto format
-- https://clang.llvm.org/docs/ClangFormat.html
vim.g.neoformat_enabled_proto = { "clangformat" }
vim.g.neoformat_cpp_clangformat = {
	exe = "clang-format",
	args = { "--style=file" },
	stdin = true,
}
