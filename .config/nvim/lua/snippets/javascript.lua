local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local extras = require("luasnip.extras")
local fmt = require("luasnip.extras.fmt").fmt
local rep = extras.rep

return {
    s("cl", fmt('console.log("{}", {});', { i(1), rep(1) })),
    s({
        trig = "afta",
        name = "afterAll block",
        dscr = "Inserts an afterAll block",
    }, {
        t("beforAll('"),
        i(1, ""),
        t("', async() => {"),
        i(0),
        t({ "", "});" }),
    }),
    s({
        trig = "aft",
        name = "afterEach block",
        dscr = "Inserts an afterEach block",
    }, {
        t("afterach('"),
        i(1, ""),
        t("', async() => {"),
        i(0),
        t({ "", "});" }),
    }),
    s({
        trig = "befa",
        name = "beforeAll block",
        dscr = "Inserts a beforeAll block",
    }, {
        t("beforAll('"),
        i(1, ""),
        t("', async() => {"),
        i(0),
        t({ "", "});" }),
    }),
    s({
        trig = "bef",
        name = "beforeEach block",
        dscr = "Inserts a beforeEach block",
    }, {
        t("beforEach('"),
        i(1, ""),
        t("', async() => {"),
        i(0),
        t({ "", "});" }),
    }),
    s({
        trig = "cont",
        name = "context block",
        dscr = "Inserts a context block",
    }, {
        t("context('"),
        i(1, ""),
        t("', () => {"),
        i(0),
        t({ "", "});" }),
    }),
    s({
        trig = "desc",
        name = "describe block",
        dscr = "Inserts a describe block",
    }, {
        t("describe('"),
        i(1, ""),
        t("', () => {"),
        i(0),
        t({ "", "});" }),
    }),
    s({
        trig = "it",
        name = "it block",
        dscr = "Inserts an it block",
    }, {
        t("it('"),
        i(1, ""),
        t("', async () => {"),
        i(0),
        t({ "", "});" }),
    }),
    --[[
  ]]
    --
    s({
        trig = "ajaxcomplete",
        descr = "(ajaxcomplete)",
        priority = -1000,
        --trigEngine = te("w")
    }, {
        i(1, "obj", { key = "i1" }),
        t(".ajaxComplete(function ("),
        i(1, "e", { key = "i1" }),
        t(", xhr, settings) {"),
        --nl(),
        t("\t"),
        i(0, "// callback", { key = "i0" }),
        --nl(),
        t("});"),
    }),
}
