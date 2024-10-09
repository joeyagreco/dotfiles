-- check module status: :TSModuleInfo
-- toggle highlighting: :TSBufToggle highlight
return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    opts = {
        ensure_installed = { "go", "gomod", "python", "typescript", "javascript" },
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

        -- fold config
        -- https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#folding
        vim.opt.foldmethod = "expr"
        vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
        vim.opt.foldlevel = 99
    end,
}
