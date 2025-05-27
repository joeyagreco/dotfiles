local RUFF_CONFIG_FILE = vim.fn.expand("$HOME/pyproject.toml")
-- https://github.com/stevearc/conform.nvim
-- see info with ":ConformInfo"
return {
    "stevearc/conform.nvim",
    lazy = true,
    event = "BufEnter",
    -- https://github.com/stevearc/conform.nvim?tab=readme-ov-file#options
    opts = {
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
            jsonc = { "fixjson" },
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
        format_on_save = {
            -- These options will be passed to conform.format()
            timeout_ms = 500,
            lsp_format = "never",
        },
    },
}
