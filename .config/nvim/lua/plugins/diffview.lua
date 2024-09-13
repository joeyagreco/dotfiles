-- https://github.com/sindrets/diffview.nvim
return {
    "sindrets/diffview.nvim",
    lazy = false,
    config = function()
        require("diffview").setup()
    end,
}
