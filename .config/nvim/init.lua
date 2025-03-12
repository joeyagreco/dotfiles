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
