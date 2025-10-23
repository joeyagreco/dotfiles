-- https://github.com/akinsho/git-conflict.nvim
return {
    "akinsho/git-conflict.nvim",
    -- NOTE: @joeyagreco - if we lazy load this plugin it does not seem to work, for now just don't lazy load
    -- event = "VeryLazy",
    config = function()
        require("git-conflict").setup({
            default_mappings = {
                ours = "co",
                theirs = "ct",
                none = "c0",
                both = "cb",
                next = "cc",
                prev = "CC",
            },
        })
        -- open merge conflicts in quickfix list
        vim.api.nvim_create_user_command("Con", "GitConflictListQf", { desc = "open merge conflicts in quickfix list" })
    end,
}
