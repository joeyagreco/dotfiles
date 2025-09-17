local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
    s({ trig = "cl", name = "fmt.Println statement" }, { t("fmt.Println("), i(0), t(")") }),
    s({ trig = "fc", name = "function" }, { t("func "), i(1, "name"), t("("), i(2), t(") "), i(3), t(" {"), t({ "", "    " }), i(0), t({ "", "}" }) }),
}

