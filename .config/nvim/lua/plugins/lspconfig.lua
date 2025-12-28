-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
return {
    "neovim/nvim-lspconfig",
    lazy = true,
    event = "BufEnter",
    config = function()
        -- reduce lsp log verbosity (prevents huge log files)
        vim.lsp.set_log_level("ERROR")

        local lspconfig = require("lspconfig")
        local util = require("lspconfig.util")

        -- good func to find root dir
        local root_dir_func = function(fname)
            -- https://github.com/neovim/nvim-lspconfig/blob/541f3a2781de481bb84883889e4d9f0904250a56/doc/lspconfig.txt#L294
            -- locates the first parent directory containing a `.git` directory
            return util.find_git_ancestor(fname) or vim.fn.getcwd()
        end

        -- css
        lspconfig.cssls.setup({})

        -- golang
        lspconfig.gopls.setup({})

        -- markdown
        lspconfig.marksman.setup({})

        -- zsh
        -- NOTE: use .shellcheckrc for configuration
        lspconfig.bashls.setup({
            filetypes = { "sh", "zsh", "zshrc" },
        })

        -- terraform
        lspconfig.terraformls.setup({})

        -- toml
        lspconfig.taplo.setup({})

        -- proto
        lspconfig.protols.setup({})

        -- typescript
        lspconfig.ts_ls.setup({})

        -- python
        -- https://github.com/astral-sh/ruff
        -- NOTE: see pyproject.toml for config under tool.ruff.lint
        lspconfig.ruff.setup({
            root_dir = root_dir_func,
            cmd = { "ruff", "server", "--preview" },
            init_options = {
                settings = {
                    -- enable all ruff rules
                    lint = { enable = true },
                    format = { enable = true },
                },
            },
        })
        -- ruff lsp doesn't do "go to definition" at all (source: https://github.com/astral-sh/ruff-lsp/issues/57#issuecomment-1399540768), so use pyright too
        lspconfig.pyright.setup({
            -- tell pyright what the root dir of this python file is
            root_dir = root_dir_func,
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
        lspconfig.lua_ls.setup({
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

        -- openscad
        lspconfig.openscad_lsp.setup({
            cmd = { "openscad-lsp", "--stdio" },
            filetypes = { "openscad" },
            settings = {
                openscad = {
                    indent = "    ",
                },
            },
        })

        -- yaml
        lspconfig.yamlls.setup({
            filetypes = { "yaml", "yml" },
        })

        -- makefile
        lspconfig.efm.setup({
            filetypes = { "make" },
        })

        -- vimrc
        lspconfig.vimls.setup({})
    end,
}
