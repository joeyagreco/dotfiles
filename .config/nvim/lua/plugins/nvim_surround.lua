return {
    "kylechui/nvim-surround",
    config = function()
        -- https://github.com/kylechui/nvim-surround
        local nvim_surround = require("nvim-surround")
        -- config: https://github.com/kylechui/nvim-surround/blob/main/lua/nvim-surround/config.lua
        nvim_surround.setup()

        -- add/delete/change:
        -- ys{motion}{char}
        -- ds{char}
        -- cs{target}{replacement}
    end
}
