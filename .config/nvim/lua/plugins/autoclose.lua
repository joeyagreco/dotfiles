-- https://github.com/m4xshen/autoclose.nvim
return {
    "m4xshen/autoclose.nvim",
    lazy = true,
    event = "InsertEnter",
    opts = {
        keys = {
            ["("] = { escape = false, close = true, pair = "()" },
            ["["] = { escape = false, close = true, pair = "[]" },
            ["{"] = { escape = false, close = true, pair = "{}" },

            [">"] = { escape = true, close = false, pair = "<>" },
            [")"] = { escape = true, close = false, pair = "()" },
            ["]"] = { escape = true, close = false, pair = "[]" },
            ["}"] = { escape = true, close = false, pair = "{}" },

            ['"'] = { escape = true, close = true, pair = '""' },
            -- no clear workaround for making this work
            -- EXAMPLE: > [try to type "didn't"]
            --          > didn''t
            -- for now just disable autoclose for ' by setting `close = false`
            -- GITHUB ISSUE LINK: https://github.com/m4xshen/autoclose.nvim/issues/55
            ["'"] = { escape = true, close = false, pair = "''" },
            ["`"] = { escape = true, close = true, pair = "``" },
        },
        options = {
            disabled_filetypes = { "text" },
            disable_when_touch = true,
            touch_regex = "[%w(%[{]",
            pair_spaces = true,
            auto_indent = true,
            disable_command_mode = true,
        },
    },
}
