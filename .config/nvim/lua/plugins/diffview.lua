-- https://github.com/sindrets/diffview.nvim

return {
    "sindrets/diffview.nvim",
    lazy = true,
    cmd = { "Blame", "DifBranch" },
    config = function()
        require("diffview").setup({
            keymaps = {
                file_panel = {
                    -- open the current selected file in a new buffer and close the dif view
                    ["go"] = function()
                        local lib = require("diffview.lib")
                        local view = lib.get_current_view()

                        if not view then
                            vim.notify("no diffview found", vim.log.levels.ERROR)
                            return
                        end

                        local file = view:infer_cur_file()

                        if not file or not file.absolute_path then
                            vim.notify("no file selected", vim.log.levels.ERROR)
                            return
                        end

                        local file_path = file.absolute_path
                        vim.cmd("DiffviewClose")
                        vim.schedule(function()
                            vim.cmd("edit " .. vim.fn.fnameescape(file_path))
                        end)
                    end,
                },
            },
        })

        -- TODO: @joeyagreco - decide if i wanna use this or the <leader>D keymap
        -- -- open git dif view
        -- vim.api.nvim_create_user_command("Dif", ":lua require('diffview').open()<CR>", { desc = "Open DiffView" })

        -- show git blame for current buffer
        vim.api.nvim_create_user_command("Blame", function()
            require("diffview")
            vim.cmd("DiffviewFileHistory %")
        end, { desc = "show git blame for current buffer" })

        -- compare current changes against a specific branch
        vim.api.nvim_create_user_command("DifBranch", function(opts)
            local branch = opts.args
            if branch == "" or branch == nil then
                -- TODO: for some reason we get a bad error the first time we don't give a branch name, after that we get this nice error
                vim.notify("please provide a branch name", vim.log.levels.ERROR)
                return
            end
            require("diffview").open(branch)
        end, { nargs = "*", complete = "file", desc = "compare diff against specific branch" })
    end,

    keys = {
        {
            "<leader>D",
            ":lua require('diffview').open()<CR>",
            desc = "open git dif view",
            silent = true,
            noremap = true,
        },
    },
}
