-- https://github.com/kylechui/nvim-surround
return {
    "kylechui/nvim-surround",
    lazy = false,
    config = function()
        -- config: https://github.com/kylechui/nvim-surround/blob/main/lua/nvim-surround/config.lua
        require("nvim-surround").setup()

        -- add/delete/change:
        -- ys{motion}{char}
        -- ds{char}
        -- cs{target}{replacement}
    end,
}
