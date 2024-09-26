-- https://github.com/f-person/git-blame.nvim
return {
    "f-person/git-blame.nvim",
    lazy = true,
    event = "BufEnter",
    cmd = { "Url" },
    config = function()
        require("gitblame").setup({
            enabled = true,
            date_format = "%b %-d, %Y",
            delay = 100, -- ms
            message_template = " <summary> • <author> • <date>",
            message_when_not_committed = "[ not committed ]",
            display_virtual_text = false,
            max_commit_summary_length = 50,
        })
        -- copy url of current line in git
        vim.api.nvim_create_user_command("Url", function()
            vim.cmd("GitBlameCopyFileURL")
            print("git url copied")
        end, { desc = "copy url of current line in git" })
    end,
}
