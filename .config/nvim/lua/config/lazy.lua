local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- https://lazy.folke.io/configuration
-- https://lazy.folke.io/usage
-- lazy loading events: https://lazy.folke.io/usage#-user-events
-- to disable a plugin, do "enabled = false" in that plugins object
require("lazy").setup({
    spec = {
        { import = "plugins" },
    },
    rocks = {
        enabled = false,
    },
    install = { colorscheme = { "material" } },
    -- automatically check for plugin updates
    checker = { enabled = true },
    change_detection = {
        enabled = true,
        notify = false,
    },
    defaults = {
        version = "*",
    },
})
