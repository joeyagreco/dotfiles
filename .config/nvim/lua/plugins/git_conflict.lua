return {
    "akinsho/git-conflict.nvim",
    lazy = true,
    event = "BufEnter",
    opts = {
        default_mappings = {
            ours = "co",
            theirs = "ct",
            none = "c0",
            both = "cb",
            next = "cc",
            prev = "CC",
        },
    },
}
