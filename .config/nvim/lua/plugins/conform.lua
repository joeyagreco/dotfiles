local RUFF_CONFIG_FILE = vim.fn.expand("$HOME/pyproject.toml")
-- https://github.com/stevearc/conform.nvim
-- see info with ":ConformInfo"
return {
    "stevearc/conform.nvim",
    lazy = true,
    event = "BufEnter",
    cmd = { "Format" },
    -- https://github.com/stevearc/conform.nvim?tab=readme-ov-file#options
    config = function()
        require("conform").setup({
            format_on_save = function(bufnr)
                -- Disable with a global or buffer-local variable
                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                    return
                end
                return { timeout_ms = 500, lsp_format = "never" }
            end,
            log_level = vim.log.levels.INFO,
            -- built in formatters: https://github.com/stevearc/conform.nvim?tab=readme-ov-file#formatters
            formatters_by_ft = {
                css = { "prettier" },
                go = { "gofmt", "goimports" },
                html = { "prettier" },
                javascript = { "prettier" },
                javascriptreact = { "prettier" },
                -- https://github.com/rhysd/fixjson
                json = { "fixjson" },
                jsonc = { "prettier" },
                lua = { "stylua" },
                proto = { "buf" },
                python = { "ruff_check", "ruff_fmt" },
                sh = { "shfmt" },
                terraform = { "terraform_fmt" },
                hcl = { "terraform_fmt" },
                toml = { "taplo" },
                typescript = { "prettier" },
                typescriptreact = { "prettier" },
                xml = { "xmlstarlet" },
                yaml = {},
                yml = {},
                zsh = { "shfmt" },
            },
            formatters = {
                ruff_check = {
                    inherit = false,
                    stdin = true,
                    command = "ruff",
                    -- for now, don't need the config file but if we need in future use this format to use it
                    -- args = { "check", "-", "--config", RUFF_CONFIG_FILE, "--fix", "-q" },
                    args = { "check", "-", "--fix", "-q" },
                },
                ruff_fmt = {
                    inherit = false,
                    stdin = true,
                    command = "ruff",
                    args = { "format", "-", "--config", RUFF_CONFIG_FILE, "-q" },
                },
            },
        })

        -- https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#command-to-toggle-format-on-save
        vim.api.nvim_create_user_command("Format", function(args)
            vim.b.disable_autoformat = not vim.b.disable_autoformat
        end, {
            desc = "toggle autoformat",
        })
    end,
}
