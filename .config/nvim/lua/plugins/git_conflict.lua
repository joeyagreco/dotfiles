return {
    "akinsho/git-conflict.nvim",
    lazy = false,
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
