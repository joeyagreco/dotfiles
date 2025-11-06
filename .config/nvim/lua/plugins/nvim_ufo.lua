vim.opt.foldmethod = "manual" -- https://github.com/kevinhwang91/nvim-ufo/issues/290#issuecomment-2775919030
vim.opt.foldexpr = nil
vim.opt.foldlevel = 999
vim.opt.foldenable = true

-- shows number of lines for folded text
local handler = function(virt_text, lnum, end_lnum, width, truncate)
    local new_virt_text = {}
    -- local collapse_char = "󰁂"
    local collapse_char = "…"
    local suffix = ("%s%s %d"):format(" ", collapse_char, end_lnum - lnum)

    local suf_width = vim.fn.strdisplaywidth(suffix)
    local target_width = width - suf_width
    local cur_width = 0
    for _, chunk in ipairs(virt_text) do
        local chunk_text = chunk[1]
        local chunk_width = vim.fn.strdisplaywidth(chunk_text)
        if target_width > cur_width + chunk_width then
            table.insert(new_virt_text, chunk)
        else
            chunk_text = truncate(chunk_text, target_width - cur_width)
            local hl_group = chunk[2]
            table.insert(new_virt_text, { chunk_text, hl_group })
            chunk_width = vim.fn.strdisplaywidth(chunk_text)
            if cur_width + chunk_width < target_width then
                suffix = suffix .. (" "):rep(target_width - cur_width - chunk_width)
            end
            break
        end
        cur_width = cur_width + chunk_width
    end
    table.insert(new_virt_text, { suffix, "MoreMsg" })
    return new_virt_text
end

-- https://github.com/kevinhwang91/nvim-ufo
return {
    "kevinhwang91/nvim-ufo",
    lazy = true,
    event = { "VeryLazy" }, -- this shouldn't be needed, but when added this fixes this issue: https://github.com/kevinhwang91/nvim-ufo/issues/290
    -- pinning to this version because of this issue: https://github.com/kevinhwang91/nvim-ufo/issues/309
    version = "5b75cf5fdb74054fc8badb2e7ca9911dc0470d94",
    keys = {
        { "za", "za", desc = "toggle a fold", silent = true, noremap = true },
        {
            "zR",
            ":lua require('ufo').openAllFolds()<CR>",
            desc = "ufo open all folds",
            silent = true,
            noremap = true,
        },
        {
            "zM",
            ":lua require('ufo').closeAllFolds()<CR>",
            desc = "ufo close all folds",
            silent = true,
            noremap = true,
        },
    },
    dependencies = "kevinhwang91/promise-async",
    config = function()
        -- filters out nested folds that share the same start line (e.g. parameters inside python functions)
        -- NOTE: @joeyagreco - this makes it so i can fold a python function with multi-line function signature and it folds the function instead of just folding the signature
        local function customTreesitterProvider(bufnr)
            local ts_provider = require("ufo.provider.treesitter")
            local ranges = ts_provider.getFolds(bufnr)

            if not ranges then
                return ranges
            end

            local ft = vim.bo[bufnr].filetype
            if ft == "python" then
                local filtered = {}
                for i, range in ipairs(ranges) do
                    local is_nested = false
                    for j, other in ipairs(ranges) do
                        if i ~= j and range.startLine == other.startLine and range.endLine < other.endLine then
                            is_nested = true
                            break
                        end
                    end
                    if not is_nested then
                        table.insert(filtered, range)
                    end
                end
                return filtered
            end

            return ranges
        end

        require("ufo").setup({
            provider_selector = function(bufnr, filetype, buftype)
                if filetype == "python" then
                    return customTreesitterProvider
                end
                return { "treesitter", "indent" }
            end,
            fold_virt_text_handler = handler,
        })
    end,
}
