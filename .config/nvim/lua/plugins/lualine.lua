-- since we show search count on lualine, we can disable it from the command line
vim.opt.shortmess:append("S")

-- always show the status bar and only show ONE status bar
-- source: https://neovim.io/doc/user/options.html#'laststatus'
-- i don't think this would be needed if globalstatus config played well with alpha dashboard
-- but it doesn't so this is a workaround that seems to be unintrusive
vim.o.laststatus = 3

-- https://github.com/nvim-lualine/lualine.nvim
return {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    requires = { "nvim-tree/nvim-web-devicons", opt = true },
    config = function()
        local lualine = require("lualine")
        local gitblame = require("gitblame")

        local function get_line_count()
            return vim.api.nvim_buf_line_count(0) .. " lines"
        end

        lualine.setup({
            options = {
                -- themes: https://github.com/nvim-lualine/lualine.nvim/blob/master/THEMES.md
                theme = "auto",
                refresh = {
                    statusline = 200,
                    tabline = 500,
                    winbar = 300,
                },
                -- disabled_filetypes = { "packer", "NvimTree" },
            },
            -- not sure i prefer this to just disabling lualine when nvimtree is focused
            extensions = { "nvim-tree" },
            globalstatus = true,
            sections = {
                lualine_a = { { "mode", padding = 2 } },
                lualine_b = { "branch", "diff", "diagnostics" },
                lualine_c = {
                    {
                        "filename",
                        -- 0: Just the filename
                        -- 1: Relative path
                        -- 2: Absolute path
                        -- 3: Absolute path, with tilde as the home directory
                        -- 4: Filename and parent dir, with tilde as the home directory
                        path = 1,
                        symbols = {
                            modified = "", -- Text to show when the file is modified.
                            readonly = "", -- Text to show when the file is non-modifiable or readonly.
                            unnamed = "", -- Text to show for unnamed buffers.
                            newfile = "", -- Text to show for newly created file before first write.
                        },
                    },
                },
                lualine_x = {
                    {
                        "searchcount",
                        maxcount = 9999,
                        timeout = 500,
                    },
                    {
                        gitblame.get_current_blame_text,
                    },
                },
                lualine_y = { "filetype" },
                lualine_z = { get_line_count },
                -- lualine_z = {
                -- 	{
                -- 		"datetime",
                -- 		style = "%A, %B %-d | %-I:%M %p",
                -- 	},
                -- },
            },
        })
    end,
}
