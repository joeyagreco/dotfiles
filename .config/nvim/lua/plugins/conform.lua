local RUFF_CONFIG_FILE = vim.fn.expand("$HOME/pyproject.toml")

-- load machine-local format exclusions from ~/.config/nvim/local/format_exclusions.local.lua
-- this file is not committed to git and should return a table like:
-- return {
--     { filetype = "python", path_pattern = "^/Users/joey/Code/foo/" },
-- }
local format_exclusions = {}
local exclusions_file = vim.fn.expand("$HOME/.config/nvim/local/format_exclusions.local.lua")
if vim.fn.filereadable(exclusions_file) == 1 then
    local ok, exclusions = pcall(dofile, exclusions_file)
    if ok and type(exclusions) == "table" then
        format_exclusions = exclusions
    end
end

-- https://github.com/stevearc/conform.nvim
-- see info with ":ConformInfo"
return {
    "stevearc/conform.nvim",
    lazy = true,
    event = "VeryLazy",
    cmd = { "Format" },
    -- https://github.com/stevearc/conform.nvim?tab=readme-ov-file#options
    config = function()
        require("conform").setup({
            format_on_save = function(bufnr)
                -- disable with a global or buffer-local variable
                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                    return
                end

                -- check machine-local exclusions for formatting
                -- we skip formatting if we have an exclusion for this file/filetype
                local bufname = vim.api.nvim_buf_get_name(bufnr)
                local filetype = vim.bo[bufnr].filetype
                for _, exclusion in ipairs(format_exclusions) do
                    if exclusion.filetype == filetype and bufname:match(exclusion.path_pattern) then
                        return
                    end
                end

                return { timeout_ms = 500, lsp_format = "fallback" }
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
                openscad = {}, -- uses topiary and openscad-lsp for autoformat
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
                    -- manually select:
                    --	 - "I" to autosort imports
                    --	 - "F401" to remove unused imports
                    -- https://stackoverflow.com/questions/77876253/sort-imports-alphabetically-with-ruff
                    args = { "check", "-", "--fix", "-q", "--select", "I,F401" },
                },
                ruff_fmt = {
                    inherit = false,
                    stdin = true,
                    command = "ruff",
                    args = { "format", "-", "--config", RUFF_CONFIG_FILE, "-q" },
                },
            },
        })

        -- NOTE: due to the local exclusions file support added above, this may no longer be needed
        -- https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#command-to-toggle-format-on-save
        vim.api.nvim_create_user_command("Format", function(args)
            vim.b.disable_autoformat = not vim.b.disable_autoformat
        end, {
            desc = "toggle autoformat",
        })
    end,
}
