-- set completeopt to have a better completion experience
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- NOTE: @joeyagreco - here's a useful article for setup (and in the future for setting up snippets to work here): https://vonheikemen.github.io/devlog/tools/setup-nvim-lspconfig-plus-nvim-cmp/

-- https://github.com/hrsh7th/nvim-cmp
return {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    lazy = true,
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "hrsh7th/cmp-nvim-lsp-document-symbol",
    },
    opts = function()
        -- used for ghost text
        -- vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
        local cmp = require("cmp")
        local defaults = require("cmp.config.default")()
        local auto_select = true
        return {
            auto_brackets = {}, -- configure any filetype to auto add brackets
            completion = {
                completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
            },
            preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
            mapping = cmp.mapping.preset.insert({
                ["<TAB>"] = cmp.mapping.confirm({ select = auto_select }),
                ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
            }),
            -- https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources
            sources = cmp.config.sources({
                { name = "nvim_lsp", priority = 1000, max_item_count = 10 },
                { name = "path", priority = 750 },
                -- https://github.com/hrsh7th/cmp-nvim-lsp-signature-help
                { name = "nvim_lsp_signature_help", priority = 500 },
                -- https://github.com/hrsh7th/cmp-nvim-lsp-document-symbol
                { name = "nvim_lsp_document_symbol", priority = 500 },
            }, {
                -- buffer gives a lot of options and a LOT of them suck
                -- limit it by keyword length and max item count
                {
                    name = "buffer",
                    priority = 250,
                    keyword_length = 1,
                    max_item_count = 3,
                },
            }),
            formatting = {
                -- determines the order that the items in a single autocomplete line are displayed in
                fields = { "menu", "abbr", "kind" },
                format = function(entry, item)
                    local widths = {
                        -- width of the actual completion
                        abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
                        -- width of extra info to the right of the completions
                        menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 20,
                    }

                    for key, width in pairs(widths) do
                        if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
                            item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
                        end
                    end

                    -- set a unique icon for each source
                    local menu_icon = {
                        nvim_lsp = "",
                        path = "",
                        nvim_lsp_signature_help = "",
                        nvim_lsp_document_symbol = "",
                        buffer = "Ω",
                    }

                    item.menu = menu_icon[entry.source.name]

                    return item
                end,
            },

            -- used for ghost text
            -- experimental = {
            --     ghost_text = {
            --         hl_group = "CmpGhostText",
            --     },
            -- },
            sorting = defaults.sorting,
        }
    end,
}
