-- https://github.com/f-person/git-blame.nvim
return {
    "f-person/git-blame.nvim",
    lazy = true,
    config = function()
        require("gitblame").setup({
            enabled = true,
            date_format = "%b %-d, %Y",
            delay = 100, -- ms
            message_when_not_committed = "Not committed",
            display_virtual_text = false,
        })
    end,
}
