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
    cmd = { "Todo", "Note" },
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
        -- env
        ft.set("env", { "#%s" })

        -- easy tags like "NOTE" and "TODO"
        local function create_tag_command(name, tag)
            vim.api.nvim_create_user_command(name, function()
                local api = require("Comment.api")
                api.toggle.linewise.current()
                vim.cmd("normal! A ")
                vim.api.nvim_put({ tag .. ": @joeyagreco -  " }, "c", true, true)
                vim.cmd("startinsert")
            end, { desc = "Toggle comment, insert " .. tag .. " with username, and enter insert mode" })
        end

        create_tag_command("Todo", "TODO")
        create_tag_command("Note", "NOTE")
    end,
}
