local lspconfig = require("lspconfig")
local constants = require("constants")
-- this must be before requiring coq for autostart to work: https://github.com/ms-jpq/coq_nvim/issues/403
-- true = autostart
-- shut-up = autostart and don't show startup message
vim.g.coq_settings = {
	auto_start = "shut-up",
	-- autocomplete was noisy and inaccurate
	-- can tweak these until they seem nice
	clients = {
		lsp = {
			enabled = true,
		},
		snippets = {
			enabled = false,
		},
		tree_sitter = {
			enabled = false,
		},
		buffers = {
			enabled = false,
		},
		paths = {
			enabled = false,
		},
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
lspconfig.bashls.setup(coq_setup({
	filetypes = { "sh", "zsh" },
}))
-- proto
lspconfig.protols.setup(coq_setup({}))
-- typescript
lspconfig.tsserver.setup(coq_setup({}))
-- python
-- pyright config: https://github.com/microsoft/pyright/blob/main/docs/configuration.md
lspconfig.pyright.setup(coq_setup({
	settings = {
		python = {
			pythonPath = constants.PYTHON_PATH,
			analysis = {
				typeCheckingMode = "standard",
			},
		},
	},
}))
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
	settings = {
		yaml = {
			schemas = {
				kubernetes = "*.yaml",
				["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
				["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
				["http://json.schemastore.org/drone"] = ".drone.yml",
				["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
			},
		},
	},
}))
-- makefile
lspconfig.efm.setup(coq_setup({
	filetypes = { "make" },
}))
-- vimrc
lspconfig.vimls.setup(coq_setup({}))
