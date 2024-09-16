-- check module status: :TSModuleInfo
-- toggle highlighting: :TSBufToggle highlight
return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    opts = {
        ensure_installed = { "go", "python", "typescript", "javascript" },
        highlight = {
            enable = true,
        },
        indent = {
            enable = true,
        },
    },
    -- !! treesitter is not enabled unless this is run !!
    config = function(_, opts)
        require("nvim-treesitter.configs").setup(opts)
    end,
}
