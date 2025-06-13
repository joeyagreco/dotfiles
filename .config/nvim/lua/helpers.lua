local M = {}

function M.combine_tables(first_table, second_table)
    for k, v in pairs(second_table) do
        first_table[k] = v
    end
    return first_table
end

-- usage as param in lazy plugin: cond = helpers.should_load_plugin({ exclude_filetypes = { "gitcommit" } }),
function M.should_load_plugin(opts)
    opts = opts or {}
    local exclude = opts.exclude_filetypes or {}
    local current_ft = vim.bo.filetype
    for _, ft in ipairs(exclude) do
        if current_ft == ft then
            return false
        end
    end
    return true
end

-- define plugin load priority
-- (default is 50)
-- https://lazy.folke.io/spec#spec-loading
M.plugin_priority = {
    THEME = 1001,
    TELESCOPE = 1000,
}

return M
