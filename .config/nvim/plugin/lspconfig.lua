local lspconfig = require("lspconfig")
-- this must be before requiring coq for autostart to work: https://github.com/ms-jpq/coq_nvim/issues/403
-- true = autostart
-- shut-up = autostart and don't show startup message
vim.g.coq_settings = {
	auto_start = "shut-up",
}
local coq = require("coq")
-- golang
lspconfig.gopls.setup(coq.lsp_ensure_capabilities({}))
-- markdown
lspconfig.marksman.setup(coq.lsp_ensure_capabilities({}))
-- zsh
lspconfig.bashls.setup(coq.lsp_ensure_capabilities({
	filetypes = { "sh", "zsh" },
}))
-- yaml
lspconfig.yamlls.setup(coq.lsp_ensure_capabilities({
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
-- typescript
-- lua
-- python
-- proto
lspconfig.efm.setup(coq.lsp_ensure_capabilities({}))
