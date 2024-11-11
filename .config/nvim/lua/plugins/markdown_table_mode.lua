-- https://github.com/Kicamon/markdown-table-mode.nvim
return {
    "Kicamon/markdown-table-mode.nvim",
    lazy = true,
    event = "BufEnter",
    config = function()
        require("markdown-table-mode").setup()
    end,
}
