-- https://github.com/sindrets/diffview.nvim
return {
    "sindrets/diffview.nvim",
    lazy = true,
    config = function()
        require("diffview").setup()
    end,
}
