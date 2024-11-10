-- https://github.com/numToStr/Comment.nvim

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
    config = function()
        require("Comment").setup({})
        local ft = require("Comment.ft")

        -- Enable both line and block comments for filetypes that are not supported out of the box
        -- https://github.com/numToStr/Comment.nvim
        -- NOTE: can also do something like this:
        -- vim.api.nvim_create_autocmd("FileType", {
        --     pattern = "proto",
        --     callback = function()
        --         vim.bo.commentstring = "//%s"
        --     end,
        -- })

        -- proto
        ft.set("proto", { "//%s", "/*%s*/" })
        -- go.mod
        ft.set("gomod", { "//%s", "/*%s*/" })
        -- jsx
        ft.set("javascriptreact", { "{/*%s*/}", "{/*%s*/}" })
    end,
}
