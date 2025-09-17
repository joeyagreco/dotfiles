local fmt = require("luasnip.extras.fmt").fmt
local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node

return {
    s("cl", fmt("console.log({});", { i(1) })),
    s("fc", fmt("function {}({}): {} {{\n    {}\n}}", { i(1, "name"), i(2), i(3, "void"), i(0) })),
}

