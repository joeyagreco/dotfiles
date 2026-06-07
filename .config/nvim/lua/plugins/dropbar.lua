-- https://github.com/Bekaboo/dropbar.nvim
return {
    "Bekaboo/dropbar.nvim",
    lazy = true,
    event = "VeryLazy",
    opts = function()
        -- NOTE: @joeyagreco - we do all this extra crap just so this doesn't show up in certain places.. see the commit where this was added lol
        -- wrap the default enable so we can keep all of dropbar's normal behavior
        -- but never show the bar (which renders the "NvimTree_1" buffer name) in nvim-tree
        local default_enable = require("dropbar.configs").opts.bar.enable
        return {
            bar = {
                enable = function(buf, win, info)
                    if vim.bo[buf].filetype == "NvimTree" then
                        return false
                    end
                    return default_enable(buf, win, info)
                end,
            },
        }
    end,
}
