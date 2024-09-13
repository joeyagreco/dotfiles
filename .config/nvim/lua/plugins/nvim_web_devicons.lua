-- https://github.com/nvim-tree/nvim-web-devicons
return {
    "nvim-tree/nvim-web-devicons",
    lazy = false,
    config = function()
        require("nvim-web-devicons").setup()
    end,
}
