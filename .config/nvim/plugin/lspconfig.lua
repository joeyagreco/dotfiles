local lspconfig = require("lspconfig")
local coq = require("coq")
-- typescript
lspconfig.tsserver.setup(coq.lsp_ensure_capabilities({}))
-- python
lspconfig.pyright.setup(coq.lsp_ensure_capabilities({}))
-- golang
lspconfig.gopls.setup(coq.lsp_ensure_capabilities({}))
-- markdown
lspconfig.marksman.setup(coq.lsp_ensure_capabilities({}))
