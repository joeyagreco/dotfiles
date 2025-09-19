-- https://github.com/f-person/git-blame.nvim
return {
    "f-person/git-blame.nvim",
    lazy = true,
    cmd = { "Url" },
    config = function()
        require("gitblame").setup({
            enabled = true,
            date_format = "%b %-d, %Y",
            -- "this doesn't affect the performance of the plugin" - readme
            delay = 100, -- ms
            message_template = " <summary> • <author> • <date>",
            message_when_not_committed = "[ not committed ]",
            display_virtual_text = false,
            max_commit_summary_length = 50,
        })
        -- copy url of current line in git
        vim.cmd("command! -range Url call execute('<line1>,<line2>GitBlameCopyFileURL') | echo 'git url copied'")
    end,
}
