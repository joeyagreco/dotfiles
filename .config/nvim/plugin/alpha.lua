-- custom theme discussion here: https://github.com/goolord/alpha-nvim/discussions/16

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

-- Set menu
dashboard.section.buttons.val = {
	dashboard.button("n", "   New file", ":ene <BAR> startinsert <CR>"),
	dashboard.button("f", "   Find file", ":Telescope find_files<CR>"),
	dashboard.button("r", "   Recent", ":Telescope oldfiles<CR>"),
	dashboard.button("u", "󰂖   Update plugins", ":PackerSync<CR>"),
	dashboard.button("q", "   Quit NVIM", ":qa<CR>"),
}

alpha.setup(dashboard.opts)
