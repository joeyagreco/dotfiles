local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
    s(
        { trig = "inm", name = 'if __name__ == "__main__":' },
        { t('if __name__ == "__main__":'), t({ "", "    " }), i(0) }
    ),
    s({ trig = "init", name = "__init__ function" }, { t("def __init__(self):"), t({ "", "    " }), i(0) }),
    s({ trig = "str_", name = "__str__ function" }, { t("def __str__(self):"), t({ "", "    " }), i(0) }),
    s({ trig = "repr_", name = "__repr__ function" }, { t("def __repr__(self):"), t({ "", "    " }), i(0) }),
    s({ trig = "eq_", name = "__eq__ function" }, { t("def __eq__(self):"), t({ "", "    " }), i(0) }),
}
