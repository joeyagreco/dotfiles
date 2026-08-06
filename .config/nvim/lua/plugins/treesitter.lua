-- https://github.com/nvim-treesitter/nvim-treesitter

-- skip treesitter on files bigger than this
local MAX_TREESITTER_FILE_SIZE_BYTES = 1536 * 1024

return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter").setup()

        local parsers = {
            "bash",
            "css",
            "dockerfile",
            "gitignore",
            "go",
            "gomod",
            "hcl",
            "html",
            "javascript",
            "json",
            "lua",
            "make",
            "markdown",
            "proto",
            "python",
            "terraform",
            "toml",
            "typescript",
            "vim",
            "yaml",
        }
        require("nvim-treesitter").install(parsers)

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "*",
            callback = function(args)
                local stats = vim.uv.fs_stat(vim.api.nvim_buf_get_name(args.buf))
                if stats and stats.size > MAX_TREESITTER_FILE_SIZE_BYTES then
                    return
                end
                pcall(vim.treesitter.start)
            end,
        })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "*",
            callback = function(args)
                -- only use the treesitter indentexpr where treesitter actually attached
                if not vim.b[args.buf].ts_highlight then
                    return
                end
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })
    end,
}
