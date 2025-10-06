-- https://github.com/sindrets/diffview.nvim

return {
    "sindrets/diffview.nvim",
    lazy = true,
    cmd = { "Blame", "Dif", "DifBranch" },
    config = function()
        require("diffview").setup({
            keymaps = {
                file_panel = {
                    -- this will open the current selected file in the :Dif file tree in a new buffer and close the dif view
                    ["go"] = function()
                        local line = vim.api.nvim_get_current_line()
                        local filename = line:match("^%s*[MAD?!]?%s*[^%s]*%s*([^%s]+)")

                        if filename then
                            -- get git root directory
                            local handle = io.popen("git rev-parse --show-toplevel 2>/dev/null")
                            local git_root = handle:read("*a"):gsub("\n", "")
                            handle:close()

                            -- try to find the file in the git repo
                            local find_cmd = string.format("find %s -name %s -type f", git_root, filename)
                            local find_handle = io.popen(find_cmd)
                            local found_files = find_handle:read("*a")
                            find_handle:close()

                            local files = {}
                            for file in found_files:gmatch("[^\r\n]+") do
                                table.insert(files, file)
                            end

                            if #files > 0 then
                                local file_to_open = files[1] -- use first match
                                print("Opening: " .. file_to_open)
                                vim.cmd("DiffviewClose")
                                vim.schedule(function()
                                    vim.cmd("edit " .. vim.fn.fnameescape(file_to_open))
                                end)
                            else
                                print("Could not find file: " .. filename)
                            end
                        end
                    end,
                },
            },
        })

        -- open git dif view
        vim.api.nvim_create_user_command("Dif", ":lua require('diffview').open()<CR>", { desc = "Open DiffView" })

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
}
