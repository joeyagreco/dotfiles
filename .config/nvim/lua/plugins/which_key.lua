-- https://github.com/folke/which-key.nvim
return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        -- don't have some hints pop up when i start a key combo lmfao
        triggers = {},
    },
    keys = {
        {
            "<leader>W",
            function()
                require("which-key").show({ global = false })
            end,
            desc = "see keymaps",
        },
    },
}
