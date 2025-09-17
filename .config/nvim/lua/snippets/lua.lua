local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
    s({ trig = "cl", name = "print statement" }, { t("print("), i(0), t(")") }),
    s(
        { trig = "fc", name = "function" },
        { t("function "), i(1, "name"), t("("), i(2), t(")"), t({ "", "    " }), i(0), t({ "", "end" }) }
    ),
}
