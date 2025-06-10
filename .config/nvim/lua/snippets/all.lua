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
    s({ trig = "todo", name = "todo comment" }, {
        f(function()
            return comment_prefix() .. " TODO: @joeyagreco - "
        end, {}),
    }),
    s({ trig = "note", name = "note comment" }, {
        f(function()
            return comment_prefix() .. " NOTE: @joeyagreco - "
        end, {}),
    }),
    s({ trig = "fixme", name = "fixme comment" }, {
        f(function()
            return comment_prefix() .. " FIXME: @joeyagreco - "
        end, {}),
    }),
}
