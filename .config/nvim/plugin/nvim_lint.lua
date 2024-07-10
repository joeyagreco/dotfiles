-- https://github.com/mfussenegger/nvim-lint
local lint = require("lint")
lint.linters_by_ft = {
	-- https://github.com/rhysd/actionlint
	yaml = { "actionlint" },
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		-- try_lint without arguments runs the linters defined in `linters_by_ft`
		-- for the current filetype
		lint.try_lint()
	end,
})
