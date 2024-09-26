return {
    "neovim/nvim-lspconfig",
    lazy = true,
    event = "BufEnter",
    config = function()
        local lspconfig = require("lspconfig")

        -- golang
        lspconfig.gopls.setup({})

        -- markdown
        lspconfig.marksman.setup({})

        -- zsh
        -- NOTE: use .shellcheckrc for configuration
        lspconfig.bashls.setup({
            filetypes = { "sh", "zsh", "zshrc" },
        })

        -- toml
        lspconfig.taplo.setup({})

        -- proto
        lspconfig.protols.setup({})

        -- typescript
        lspconfig.ts_ls.setup({})

        -- python
        -- https://github.com/astral-sh/ruff-lsp
        lspconfig.ruff_lsp.setup({})
        -- ruff_lsp doesn't do "go to definition" at all (source: https://github.com/astral-sh/ruff-lsp/issues/57#issuecomment-1399540768), so use pyright too
        lspconfig.pyright.setup({})

        -- lua
        lspconfig.lua_ls.setup({
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
            -- on_init = yaml_on_init,
            filetypes = { "yaml", "yml", "yamlfmt" },
        })

        -- makefile
        lspconfig.efm.setup({
            filetypes = { "make" },
        })

        -- vimrc
        lspconfig.vimls.setup({})
    end,
}
