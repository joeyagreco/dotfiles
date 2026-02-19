-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
return {
    "neovim/nvim-lspconfig",
    lazy = true,
    event = "BufEnter",
    config = function()
        -- reduce lsp log verbosity (prevents huge log files)
        vim.lsp.set_log_level("ERROR")

        -- zsh
        -- NOTE: use .shellcheckrc for configuration
        vim.lsp.config("bashls", {
            filetypes = { "sh", "zsh", "zshrc" },
        })

        -- python
        -- -- https://github.com/astral-sh/ruff
        -- -- NOTE: see pyproject.toml for config under tool.ruff.lint
        -- vim.lsp.config("ruff", {
        --     cmd = { "ruff", "server", "--preview" },
        --     init_options = {
        --         settings = {
        --             -- enable all ruff rules
        --             lint = { enable = true },
        --             format = { enable = true },
        --         },
        --     },
        -- })
        -- ruff lsp doesn't do "go to definition" at all (source: https://github.com/astral-sh/ruff-lsp/issues/57#issuecomment-1399540768), so use pyright too
        vim.lsp.config("pyright", {
            before_init = function(_, config)
                -- look for .venv in the project root (for uv projects)
                -- NOTE: @joeyagreco - this allows pyright to find installed external libs !
                local root = config.root_dir
                local venv_path = root and (root .. "/.venv/bin/python")
                if venv_path and vim.fn.executable(venv_path) == 1 then
                    config.settings.python = config.settings.python or {}
                    config.settings.python.pythonPath = venv_path
                else
                    -- fallback to mise's python interpreter
                    local python_path = vim.fn.exepath("python3") or vim.fn.exepath("python")
                    if python_path ~= "" then
                        config.settings.python = config.settings.python or {}
                        config.settings.python.pythonPath = python_path
                    end
                end
            end,
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

        -- NOTE: @joeyagreco - turning off for now since it's weird
        -- -- openscad
        -- vim.lsp.config("openscad_lsp", {
        --     cmd = { "openscad-lsp", "--stdio" },
        --     filetypes = { "openscad" },
        --     settings = {
        --         openscad = {
        --             indent = "    ",
        --         },
        --     },
        -- })

        -- yaml
        vim.lsp.config("yamlls", {
            filetypes = { "yaml", "yml" },
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
            "lua_ls",
            "marksman",
            "protols",
            "pyright",
            "taplo",
            "terraformls",
            "ts_ls",
            "vimls",
            "yamlls",
        })
    end,
}
