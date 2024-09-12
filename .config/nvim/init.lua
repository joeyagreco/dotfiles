-- vim settings come before lazy
require("vim")
require("config.lazy")
-- we do theme before anything else so in case we have an issue with config at least we can fix it while neovim looks nice
require("theme")
-- TODO: use lazy autocommands: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
require("autocommands")
require("constants")
require("helpers")
require("commands")
-- TODO: use lazy keymaps: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
require("keymaps")
