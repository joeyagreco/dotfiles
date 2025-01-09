-- MATERIAL
-- vim.g.material_style = "deep ocean"
-- vim.cmd("colorscheme material")

-- NIGHTFOX
vim.cmd("colorscheme carbonfox")

-----------
-- edits --
-----------

-- make it easier to tell what is visually selected in vim
vim.api.nvim_set_hl(0, "Visual", { reverse = true })
