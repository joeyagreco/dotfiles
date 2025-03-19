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
                { name = "nvim_lsp", priority = 1000 },
                { name = "path", priority = 750 },
                -- https://github.com/hrsh7th/cmp-nvim-lsp-signature-help
                { name = "nvim_lsp_signature_help", priority = 500 },
                -- https://github.com/hrsh7th/cmp-nvim-lsp-document-symbol
                { name = "nvim_lsp_document_symbol", priority = 500 },
            }, {
                { name = "buffer", priority = 250 },
            }),
            formatting = {
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
