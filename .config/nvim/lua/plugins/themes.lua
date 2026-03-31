local helpers = require("helpers")
-- MATERIAL
-- https://github.com/marko-cerovac/material.nvim
-- return {
--     "marko-cerovac/material.nvim",
--     lazy = false,
--     opts = {},
-- }

-- NIGHTFOX
-- https://github.com/EdenEast/nightfox.nvim
return {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = helpers.plugin_priority.THEME,
    config = function()
        -- MATERIAL
        -- vim.g.material_style = "deep ocean"
        -- vim.cmd("colorscheme material")

        -- NIGHTFOX
        vim.cmd("colorscheme carbonfox")

        -----------
        -- edits --
        -----------

        -- make it easier to tell what is visually selected in vim
        vim.api.nvim_set_hl(0, "Visual", { link = "IncSearch" })
    end,
}
