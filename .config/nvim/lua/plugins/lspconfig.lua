return {
    "neovim/nvim-lspconfig",
    lazy = true,
    event = "BufEnter",
    config = function()
        local lspconfig = require("lspconfig")
        -- setting up capabilities with nvim-cmp
        -- https://github.com/hrsh7th/cmp-nvim-lsp?tab=readme-ov-file#capabilities
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- golang
        lspconfig.gopls.setup({ capabilities = capabilities })

        -- markdown
        lspconfig.marksman.setup({ capabilities = capabilities })

        -- zsh
        -- NOTE: use .shellcheckrc for configuration
        lspconfig.bashls.setup({
            capabilities = capabilities,
            filetypes = { "sh", "zsh", "zshrc" },
        })

        -- toml
        lspconfig.taplo.setup({
            capabilities = capabilities,
        })

        -- proto
        lspconfig.protols.setup({
            capabilities = capabilities,
        })

        -- typescript
        lspconfig.ts_ls.setup({
            capabilities = capabilities,
        })

        -- python
        -- https://github.com/astral-sh/ruff-lsp
        lspconfig.ruff_lsp.setup({ capabilities = capabilities })
        -- ruff_lsp doesn't do "go to definition" at all (source: https://github.com/astral-sh/ruff-lsp/issues/57#issuecomment-1399540768), so use pyright too
        lspconfig.pyright.setup({ capabilities = capabilities })

        -- lua
        lspconfig.lua_ls.setup({
            capabilities = capabilities,
            settings = {
                Lua = {
                    diagnostics = {
                        -- prevents "undefined global '<thing>'"
                        globals = { "vim", "ngx" },
                    },
                },
            },
        })

        -- yaml
        lspconfig.yamlls.setup({
            capabilities = capabilities,
            -- on_init = yaml_on_init,
            filetypes = { "yaml", "yml", "yamlfmt" },
        })

        -- makefile
        lspconfig.efm.setup({
            capabilities = capabilities,
            filetypes = { "make" },
        })

        -- vimrc
        lspconfig.vimls.setup({
            capabilities = capabilities,
        })
    end,
}
