-- https://github.com/sindrets/diffview.nvim

return {
    "sindrets/diffview.nvim",
    lazy = true,
    cmd = { "Blame", "DifBranch" },
    config = function()
        require("diffview").setup({
            keymaps = {
                file_panel = {
                    -- press ENTER to open the currently selected file in the explorer
                    -- 1. must disable default <cr> behavior (which just opens the diff)
                    { "n", "<cr>", false },
                    -- 2. create a new keymap to open the current selected file in a new buffer and close the dif view
                    {
                        "n",
                        "<cr>",
                        function()
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
                        { desc = "open file and close diffview" },
                    },
                },
            },
        })

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
            function()
                local changed = vim.fn.systemlist("git diff --name-only")
                -- don't open an empty diffview if there are no files changed
                if vim.v.shell_error ~= 0 or #changed == 0 then
                    vim.notify("no files changed", vim.log.levels.INFO)
                    return
                end
                require("diffview").open()
            end,
            desc = "open git dif view",
            silent = true,
            noremap = true,
        },
    },
}
