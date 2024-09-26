-- https://github.com/sindrets/diffview.nvim

return {
    "sindrets/diffview.nvim",
    lazy = true,
    cmd = { "Blame", "Dif" },
    opts = {},
    config = function()
        -- open git dif view
        vim.api.nvim_create_user_command("Dif", ":lua require('diffview').open()<CR>", { desc = "Open DiffView" })

        -- show git blame for current buffer
        vim.api.nvim_create_user_command("Blame", function()
            require("diffview")
            vim.cmd("DiffviewFileHistory %")
        end, { desc = "show git blame for current buffer" })
    end,
}
