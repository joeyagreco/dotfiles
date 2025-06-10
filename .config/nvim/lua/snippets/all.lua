local ls = require("luasnip")
local s = ls.snippet
local f = ls.function_node

-- function to fetch the comment string (e.g., "//", "#", etc.)
local function comment_prefix()
    local cs = vim.bo.commentstring
    -- use the part before %s, fallback to "#"
    return (cs:match("^(.*)%%s") or "#"):gsub("%s+$", "")
end

return {
    s("todo", {
        f(function()
            return comment_prefix() .. " TODO: @joeyagreco - "
        end, {}),
    }),
    s("note", {
        f(function()
            return comment_prefix() .. " NOTE: @joeyagreco - "
        end, {}),
    }),
    s("fixme", {
        f(function()
            return comment_prefix() .. " FIXME: @joeyagreco - "
        end, {}),
    }),
}
