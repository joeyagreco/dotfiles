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
            lua = { "stylua" },
            python = { "ruff_check", "ruff_fmt" },
            sh = { "shfmt" },
            zsh = { "shfmt" },
            go = { "gofmt", "goimports" },
            javascript = { "prettier" },
            javascriptreact = { "prettier" },
            html = { "prettier" },
            typescript = { "prettier" },
            -- https://github.com/rhysd/fixjson
            json = { "fixjson" },
            jsonc = { "fixjson" },
            toml = { "taplo" },
            terraform = { "terraform_fmt" },
            proto = { "buf" },
            css = { "prettier" },
            -- don't want to format .tsx files
            typescriptreact = { "prettier" },
            yml = {},
            yaml = {},
        },
        formatters = {
            ruff_check = {
                inherit = false,
                stdin = true,
                command = "ruff",
                args = { "check", "-", "--config", RUFF_CONFIG_FILE, "--fix", "-q" },
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
