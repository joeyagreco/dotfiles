-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
return {
    "neovim/nvim-lspconfig",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        -- reduce lsp log verbosity (prevents huge log files)
        vim.lsp.log.set_level("ERROR")

        -- zsh
        -- NOTE: use .shellcheckrc for configuration
        vim.lsp.config("bashls", {
            filetypes = { "sh", "zsh" },
        })

        -- lua
        vim.lsp.config("lua_ls", {
            settings = {
                Lua = {
                    -- START: add vim to the runtime
                    runtime = {
                        version = "LuaJIT", -- neovim uses luajit
                        path = vim.split(package.path, ";"),
                    },
                    workspace = {
                        library = vim.api.nvim_get_runtime_file("", true),
                        checkThirdParty = false,
                    },
                    -- END: add vim to the runtime
                    diagnostics = {
                        -- prevents "undefined global '<thing>'"
                        globals = { "ngx", "hs", "spoon" },
                    },
                },
            },
        })

        -- json
        vim.lsp.config("jsonls", {
            filetypes = { "json", "jsonc" },
        })

        -- yaml
        vim.lsp.config("yamlls", {
            filetypes = { "yaml" },
        })

        -- makefile
        vim.lsp.config("efm", {
            filetypes = { "make" },
        })

        -- enable all servers
        vim.lsp.enable({
            "bashls",
            "cssls",
            "efm",
            "gopls",
            "jsonls",
            "lua_ls",
            "marksman",
            "protols",
            "taplo",
            "terraformls",
            "ts_ls",
            "ty",
            "vimls",
            "yamlls",
        })
    end,
}
