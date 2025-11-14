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
                if require("gitsigns").next_hunk() then
                    vim.defer_fn(function()
                        vim.cmd("normal! zz")
                    end, 10) -- NOTE: - REALLY hate the 10ms delay here but doesn't seem to center unless i have it
                end
            end,
            desc = "git next hunk",
            silent = true,
            noremap = true,
        },
        {
            "<leader>gp",
            function()
                if require("gitsigns").prev_hunk() then
                    vim.defer_fn(function()
                        vim.cmd("normal! zz")
                    end, 10) -- NOTE: - REALLY hate the 10ms delay here but doesn't seem to center unless i have it
                end
            end,
            desc = "git previous hunk",
            silent = true,
            noremap = true,
        },
    },
    opts = {},
}
