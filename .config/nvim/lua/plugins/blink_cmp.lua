-- https://github.com/Saghen/blink.cmp
-- DOCS: https://cmp.saghen.dev/
return {
    "saghen/blink.cmp",
    dependencies = { "echasnovski/mini.icons", "L3MON4D3/LuaSnip" },
    version = "1.*",
    lazy = true,
    event = "InsertEnter",
    opts = {
        keymap = {
            preset = "default",
            ["<TAB>"] = { "accept", "fallback" },
            ["<C-n>"] = { "select_next", "fallback" },
            ["<C-p>"] = { "select_prev", "fallback" },
            -- closes menu, cancels autocomplete
            ["<Esc>"] = { "fallback" },
        },

        appearance = {
            nerd_font_variant = "mono",
        },

        completion = {
            documentation = { auto_show = false },

            menu = {
                draw = {
                    components = {
                        kind_icon = {
                            -- use icons from mini.icons
                            text = function(ctx)
                                local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                                return kind_icon
                            end,
                            -- use highlights from mini.icons
                            highlight = function(ctx)
                                local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                                return hl
                            end,
                        },
                        kind = {
                            -- use highlights from mini.icons
                            highlight = function(ctx)
                                local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                                return hl
                            end,
                        },
                    },
                },
            },
        },

        -- Default list of enabled providers defined so that youggjkjkjk can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
            default = { "lsp", "path", "snippets", "buffer" },
        },

        snippets = {
            preset = "luasnip",
        },

        fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
}
