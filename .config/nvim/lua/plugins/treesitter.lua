return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    run = function()
        local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
        ts_update()
    end,
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = { "go", "python", "typescript", "javascript" },
            highlight = {
                enable = true,
            },
            indent = {
                enable = true,
            },
        })
    end,
}
