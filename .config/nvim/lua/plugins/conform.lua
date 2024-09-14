local RUFF_CONFIG_FILE = vim.fn.expand("$HOME/ruff.toml")
-- https://github.com/stevearc/conform.nvim
return {
    "stevearc/conform.nvim",
    -- https://github.com/stevearc/conform.nvim?tab=readme-ov-file#options
    opts = {
        log_level = 1,
        formatters_by_ft = {
            lua = { "stylua" },
            python = { "ruff_check", "ruff_fmt" },
            proto = { "buf_fmt" },
            javascript = { "prettierd", "prettier" },
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
            buf_fmt = {
                inherit = false,
                command = "buf",
                args = { "format", "--write" },
                replace = true,
            },
        },
        format_on_save = {
            -- These options will be passed to conform.format()
            timeout_ms = 500,
            -- lsp_format = "fallback",
        },
    },
}
