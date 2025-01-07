-- https://github.com/lewis6991/gitsigns.nvim
-- to refresh, run: ":Gitsigns refresh"
-- test 1
return {
    "lewis6991/gitsigns.nvim",
    -- pin to main due to this issue which is on version 0.9.0 but not main branch: https://github.com/lewis6991/gitsigns.nvim/issues/1127#issuecomment-2481495017
    branch = "main",
    lazy = true,
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
            "<leader>gp",
            ":lua require('gitsigns').preview_hunk()<CR>",
            desc = "git preview current cursor hunk",
            silent = true,
            noremap = true,
        },
    },
    event = "BufEnter",
    opts = { debug_mode = false },
}
