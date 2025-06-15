-- https://github.com/nvim-treesitter/nvim-treesitter
-- check module status: :TSModuleInfo
-- toggle highlighting: :TSBufToggle highlight
return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    opts = {
        ensure_installed = { "go", "gomod", "python", "typescript", "javascript", "terraform", "css" },
        highlight = {
            enable = true,
        },
        indent = {
            enable = true,
        },
    },
    build = ":TSUpdate",
    -- !! treesitter is not enabled unless this is run !!
    config = function(_, opts)
        require("nvim-treesitter.configs").setup(opts)
    end,
}
