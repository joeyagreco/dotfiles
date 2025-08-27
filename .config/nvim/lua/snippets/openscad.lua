-- for inspiration: https://github.com/elliotf/neovim-config/blob/elliotf/snippets/openscad.lua

local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node

local extras = require("luasnip.extras")
local fmt = require("luasnip.extras.fmt").fmt
local rep = extras.rep

return {
    s("cl", fmt('echo("{}: ", {});', { i(1), rep(1) })),
    s(
        "mod",
        fmt(
            [[module {}() {{
  {}
}}]],
            { i(1), i(0) }
        )
    ),
    s(
        "trans",
        fmt(
            [[translate([0,0,0]) {{
  {}
}}]],
            { i(0) }
        )
    ),
}
