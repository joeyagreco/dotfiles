-- https://github.com/f-person/git-blame.nvim
return {
    "f-person/git-blame.nvim",
    lazy = true,
    event = "BufEnter",
    opts = {
        enabled = true,
        date_format = "%b %-d, %Y",
        delay = 100, -- ms
        message_template = " <summary> • <author> • <date>",
        message_when_not_committed = "[ not committed ]",
        display_virtual_text = false,
    },
}
