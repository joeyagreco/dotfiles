-- https://github.com/echasnovski/mini.comment
return {
    "echasnovski/mini.comment",
    version = "*",
    lazy = true,
    keys = {
        {
            "<leader>/",
            "gcc",
            mode = "n",
            desc = "Toggle comment (line)",
            remap = true,
        },
        {
            "<leader>/",
            "gc",
            mode = "x",
            desc = "Toggle comment (visual)",
            remap = true,
        },
    },
    opts = {},
}
