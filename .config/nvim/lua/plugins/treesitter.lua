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
}
