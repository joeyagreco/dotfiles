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
    -- version key isn't working so we pinning to the 1.4.0 commit hash for now
    -- version = "1.4.0",
    commit = "c15fed422506a130a62e5e79c2d754392231d7d8",
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
    opts = {
        provider_selector = function(bufnr, filetype, buftype)
            return { "treesitter", "indent" }
        end,
        fold_virt_text_handler = handler,
    },
}
