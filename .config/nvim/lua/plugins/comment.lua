return {
    "numtostr/comment.nvim",
    lazy = true,
    keys = {
        {
            "<leader>/",
            ":lua require('Comment.api').toggle.linewise.current()<CR>",
            desc = "comment current line",
            silent = true,
            noremap = true,
        },
        {
            mode = { "v" },
            "<leader>/",
            "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
            desc = "comment current selection",
            silent = true,
            noremap = true,
        },
    },
    opts = {},
}
