-- enable experimental lua module loader (supposed to speed up loading of lua modules with some caching magic)
-- https://neovim.io/doc/user/lua/#vim.loader.enable()
vim.loader.enable()

-- vim settings come before lazy
require("vim")
require("config.lazy")
-- we do theme before anything else so in case we have an issue with config at least we can fix it while neovim looks nice
require("theme")
require("autocommands")
require("constants")
require("helpers")
require("commands")
require("keymaps")
