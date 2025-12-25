-- custom picker using native neovim floating windows
return {
    dir = vim.fn.stdpath("config") .. "/lua/local_plugins/picker",
    name = "picker",
    config = function()
        require("local_plugins.picker").setup()
    end,
}
