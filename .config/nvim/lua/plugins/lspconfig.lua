-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
return {
    "neovim/nvim-lspconfig",
    lazy = true,
    event = "BufEnter",
    config = function()
        local lspconfig = require("lspconfig")
        local util = require("lspconfig.util")
        -- setting up capabilities with nvim-cmp
        -- https://github.com/hrsh7th/cmp-nvim-lsp?tab=readme-ov-file#capabilities
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- good func to find root dir
        local root_dir_func = function(fname)
            -- https://github.com/neovim/nvim-lspconfig/blob/541f3a2781de481bb84883889e4d9f0904250a56/doc/lspconfig.txt#L294
            -- locates the first parent directory containing a `.git` directory
            return util.find_git_ancestor(fname) or vim.fn.getcwd()
        end

        -- css
        lspconfig.cssls.setup({ capabilities = capabilities })

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

        -- terraform
        lspconfig.terraformls.setup({
            capabilities = capabilities,
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
        lspconfig.ruff.setup({ capabilities = capabilities, root_dir = root_dir_func })
        -- ruff lsp doesn't do "go to definition" at all (source: https://github.com/astral-sh/ruff-lsp/issues/57#issuecomment-1399540768), so use pyright too
        lspconfig.pyright.setup({
            capabilities = capabilities,
            -- tell pyright what the root dir of this python file is
            root_dir = root_dir_func,
        })

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
            filetypes = { "yaml", "yml" },
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
