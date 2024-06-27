-- custom theme discussion here: https://github.com/goolord/alpha-nvim/discussions/16
-- this specific theme: https://github.com/mohammedbabiker/dotfiles/blob/main/.config/nvim/lua/plugins/alpha.lua

local alpha = require("alpha")
local alpha_themes = require("alpha.themes.startify")
local dashboard = require("alpha.themes.dashboard")

dashboard.section.header.val = {
	[[                                                                       ]],
	[[                                                                       ]],
	[[                                                                       ]],
	[[                                                                       ]],
	[[                                                                       ]],
	[[                                                                       ]],
	[[                                                                       ]],
	[[                                                                     ]],
	[[       ████ ██████           █████      ██                     ]],
	[[      ███████████             █████                             ]],
	[[      █████████ ███████████████████ ███   ███████████   ]],
	[[     █████████  ███    █████████████ █████ ██████████████   ]],
	[[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
	[[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
	[[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
	[[                                                                       ]],
	[[                                                                       ]],
	[[                                                                       ]],
}

-- menu
dashboard.section.buttons.val = {
	--dashboard.button("n", "   New file", ":ene <BAR> startinsert <CR>"),
	dashboard.button("f", "   Find file", ":Telescope find_files<CR>"),
	dashboard.button("r", "   Recent", ":Telescope oldfiles<CR>"),
	dashboard.button(
		"g",
		"󰉋   Open git directory",
		":lua require('helpers').prompt_and_open_git_repo()<CR>",
		{ silent = true }
	),
	dashboard.button("p", "󰂖   Clean and update plugins", ":lua require('helpers').clean_and_update_plugins()<CR>"),
	dashboard.button("q", "   Quit NVIM", ":qa<CR>"),
}

-- footer

local function footer()
	return "Welcome, Joey"
end
dashboard.section.footer.val = footer()

alpha.setup(dashboard.opts)
