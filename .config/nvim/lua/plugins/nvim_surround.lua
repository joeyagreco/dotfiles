-- https://github.com/kylechui/nvim-surround
return {
    "kylechui/nvim-surround",
    lazy = false,
    config = function()
        local nvim_surround = require("nvim-surround")
        -- config: https://github.com/kylechui/nvim-surround/blob/main/lua/nvim-surround/config.lua
        nvim_surround.setup()

        -- add/delete/change:
        -- ys{motion}{char}
        -- ds{char}
        -- cs{target}{replacement}
    end,
}
