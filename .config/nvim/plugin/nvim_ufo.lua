-- https://github.com/kevinhwang91/nvim-ufo
local ufo = require("ufo")
ufo.setup({
	provider_selector = function(bufnr, filetype, buftype)
		return { "treesitter", "indent" }
	end,
})
