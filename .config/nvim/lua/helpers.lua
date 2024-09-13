local M = {}

function M.clean_and_update_plugins()
    vim.cmd("PackerClean")
    vim.cmd("PackerUpdate")
end

function M.combine_tables(first_table, second_table)
    for k, v in pairs(second_table) do
        first_table[k] = v
    end
    return first_table
end

return M
