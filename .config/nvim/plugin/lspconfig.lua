local lspconfig = require("lspconfig")
-- this must be before requiring coq for autostart to work: https://github.com/ms-jpq/coq_nvim/issues/403
-- true = autostart
-- shut-up = autostart and don't show startup message
vim.g.coq_settings = {
	auto_start = "shut-up",
}
local coq = require("coq")
-- typescript
lspconfig.tsserver.setup(coq.lsp_ensure_capabilities({}))
-- python
lspconfig.pyright.setup(coq.lsp_ensure_capabilities({}))
-- golang
lspconfig.gopls.setup(coq.lsp_ensure_capabilities({}))
-- markdown
lspconfig.marksman.setup(coq.lsp_ensure_capabilities({}))
-- protobuf
lspconfig.protols.setup(coq.lsp_ensure_capabilities({}))
