local lspconfig = require("lspconfig")

-- this must be before requiring coq for autostart to work: https://github.com/ms-jpq/coq_nvim/issues/403
-- true = autostart
-- shut-up = autostart and don't show startup message
vim.g.coq_settings = {
	auto_start = "shut-up",
	-- autocomplete was noisy and inaccurate
	-- can tweak these until they seem nice
	clients = {
		-- https://github.com/ms-jpq/coq_nvim?tab=readme-ov-file#lsp
		lsp = {
			enabled = true,
		},
		-- https://github.com/ms-jpq/coq_nvim?tab=readme-ov-file#snippets
		snippets = {
			enabled = false,
		},
		-- https://github.com/ms-jpq/coq_nvim?tab=readme-ov-file#treesitter
		tree_sitter = {
			enabled = true,
		},
		-- https://github.com/ms-jpq/coq_nvim?tab=readme-ov-file#buffers
		buffers = {
			enabled = true,
		},
		-- https://github.com/ms-jpq/coq_nvim?tab=readme-ov-file#paths
		paths = {
			enabled = true,
		},
		-- https://github.com/ms-jpq/coq_nvim?tab=readme-ov-file#ctags
		tags = {
			enabled = false,
		},
	},
}
local coq = require("coq")
local coq_setup = coq.lsp_ensure_capabilities

-- golang
lspconfig.gopls.setup(coq_setup({}))

-- markdown
lspconfig.marksman.setup(coq_setup({}))

-- zsh
-- NOTE: use .shellcheckrc for configuration
lspconfig.bashls.setup(coq_setup({
	filetypes = { "sh", "zsh", "zshrc" },
}))

-- toml
lspconfig.taplo.setup(coq_setup({}))

-- proto
lspconfig.protols.setup(coq_setup({}))

-- typescript
lspconfig.tsserver.setup(coq_setup({}))

-- python
-- https://github.com/astral-sh/ruff-lsp
lspconfig.ruff_lsp.setup(coq_setup({}))
-- disabling to use only ruff-lsp
-- -- pyright config: https://github.com/microsoft/pyright/blob/main/docs/configuration.md
-- lspconfig.pyright.setup(coq_setup({
-- 	cmd = { "pyright-langserver", "--stdio" },
-- }))

-- lua
lspconfig.lua_ls.setup({
	settings = {
		Lua = {
			diagnostics = {
				-- prevents "undefined global 'vim'"
				globals = { "vim" },
			},
		},
	},
})

-- yaml
lspconfig.yamlls.setup(coq_setup({
	-- on_init = yaml_on_init,
	filetypes = { "yaml", "yml", "yamlfmt" },
}))

-- makefile
lspconfig.efm.setup(coq_setup({
	filetypes = { "make" },
}))

-- vimrc
lspconfig.vimls.setup(coq_setup({}))
