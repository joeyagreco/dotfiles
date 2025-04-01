-- https://github.com/kylechui/nvim-surround

-- config: https://github.com/kylechui/nvim-surround/blob/main/lua/nvim-surround/config.lua

-- add/delete/change:
-- ys{motion}{char}
-- ds{char}
-- cs{target}{replacement}
return {
    "kylechui/nvim-surround",
    lazy = true,
    event = "InsertEnter",
    opts = {},
    -- disabling while trying out mini.surround
    enabled = false,
}
