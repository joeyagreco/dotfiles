-- https://github.com/lewis6991/gitsigns.nvim
-- to refresh, run: ":Gitsigns refresh"
return {
    "lewis6991/gitsigns.nvim",
    version = "*",
    lazy = true,
    event = "VeryLazy",
    keys = {
        {
            "<leader>gr",
            ":lua require('gitsigns').reset_hunk()<CR>",
            desc = "git reset current cursor hunk",
            silent = true,
            noremap = true,
        },
        {
            "<leader>gR",
            ":lua require('gitsigns').reset_buffer()<CR>",
            desc = "git reset current buffer",
            silent = true,
            noremap = true,
        },
        {
            "<leader>gs",
            ":lua require('gitsigns').preview_hunk()<CR>",
            desc = "show git preview of current cursor hunk",
            silent = true,
            noremap = true,
        },
        {
            "<leader>gn",
            function()
                require("gitsigns").nav_hunk("next", nil, function()
                    vim.cmd("normal! zz")
                end)
            end,
            desc = "git next hunk",
            silent = true,
            noremap = true,
        },
        {
            "<leader>gp",
            function()
                require("gitsigns").nav_hunk("prev", nil, function()
                    vim.cmd("normal! zz")
                end)
            end,
            desc = "git previous hunk",
            silent = true,
            noremap = true,
        },
    },
    opts = {},
}
