-- https://github.com/m4xshen/autoclose.nvim
return {
    "m4xshen/autoclose.nvim",
    lazy = true,
    event = "InsertEnter",
    opts = {
        options = {
            disable_command_mode = true,
            pair_spaces = true,
            -- when next to a char, don't autoclose
            disable_when_touch = true,
            touch_regex = "[%w%(%[{%$]",
        },
    },
}
