local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
    s({ trig = "cl", name = "print statement" }, { t("print("), i(0), t(")") }),
}

