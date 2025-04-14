-- https://github.com/folke/which-key.nvim
return {
    "folke/which-key.nvim",
    lazy = true,
    keys = {
        {
            "<leader>W",
            function()
                require("which-key").show({ global = false })
            end,
            desc = "see keymaps",
        },
    },
    -- configuration: https://github.com/folke/which-key.nvim?tab=readme-ov-file#%EF%B8%8F-configuration
    opts = {
        triggers = {}, -- don't have some hints pop up when i start a key combo lmfao
        plugins = {
            marks = false, -- don't show a list of marks on ' and `
            registers = false, -- don't show a list of registers on "
            spelling = {
                enabled = false,
            },
        },
        win = {
            no_overlap = false, -- allow the popup to overlap with the cursor
        },
    },
}
