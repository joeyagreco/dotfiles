local fmt = require("luasnip.extras.fmt").fmt
local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node

return {
    s("cl", fmt("console.log({});", { i(1) })),
}

