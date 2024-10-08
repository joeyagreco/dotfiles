-- https://github.com/folke/which-key.nvim
return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
        {
            "<leader>W",
            function()
                require("which-key").show({ global = false })
            end,
            desc = "Buffer Local Keymaps (which-key)",
        },
    },
}
