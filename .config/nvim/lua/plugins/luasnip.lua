return {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    lazy = true,
    event = "InsertEnter",
    config = function()
        local ls = require("luasnip")
        ls.config.set_config({
            updateevents = "TextChanged,TextChangedI",
        })
        require("luasnip.loaders.from_lua").load({
            paths = { "~/.config/nvim/lua/snippets" },
        })
    end,
}
