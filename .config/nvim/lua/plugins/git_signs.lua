-- to refresh, run: ":Gitsigns refresh"
return {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    config = function()
        -- trying this because it seems to not work with opts
        require("gitsigns").setup()
    end,
}
