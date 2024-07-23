vim.cmd("source ~/.vimrc")

-- we do theme first so in case we have an issue with config at least we can fix it while neovim looks nice
require("theme")
require("settings")
require("vim")
require("keymaps")
require("commands")
