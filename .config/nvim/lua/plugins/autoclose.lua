return {
	"m4xshen/autoclose.nvim",
	-- https://github.com/m4xshen/autoclose.nvim
	config = function()
		require("autoclose").setup({
			options = {
				disable_command_mode = true,
				pair_spaces = true,
				-- when next to a char, don't autoclose
				disable_when_touch = true,
				touch_regex = "[%w%(%[{%$]",
			},
		})
	end,
}
