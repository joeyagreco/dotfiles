local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
    s({ trig = "cl", name = "fmt.Println statement" }, { t("fmt.Println("), i(0), t(")") }),
}

