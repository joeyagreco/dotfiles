-- enable experimental lua module loader (supposed to speed up loading of lua modules with some caching magic)
-- https://neovim.io/doc/user/lua/#vim.loader.enable()
vim.loader.enable()

-- vim settings come before lazy
-- nvim theme is loaded via the plugin config in plugins/themes.lua
require("vim")
require("config.lazy")
require("autocommands")
require("constants")
require("helpers")
require("commands")
require("keymaps")
