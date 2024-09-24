return {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
    },
    opts = function()
        vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
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
                ["<TAB>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                ["<S-TAB>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                ["<CR>"] = cmp.mapping.confirm({ select = auto_select }),
            }),
            sources = cmp.config.sources({
                -- { name = "nvim_lsp" },
                { name = "lspconfig" },
                { name = "path" },
            }, {
                { name = "buffer" },
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
            experimental = {
                ghost_text = {
                    hl_group = "CmpGhostText",
                },
            },
            sorting = defaults.sorting,
        }
    end,
}
