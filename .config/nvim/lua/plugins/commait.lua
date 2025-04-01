return {
    {
        dir = vim.fn.stdpath("config") .. "/lua/local_plugins/commait",
        name = "commait",
        config = function()
            require("local_plugins.commait").setup()
        end,
        lazy = false,
        enabled = false,
    },
}
