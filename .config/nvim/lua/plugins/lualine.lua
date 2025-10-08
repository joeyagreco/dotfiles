-- since we show search count on lualine, we can disable it from the command line
vim.opt.shortmess:append("S")

-- don't show mode by default in vim since lualine shows it
vim.opt.showmode = false

-- always show the status bar and only show ONE status bar
-- source: https://neovim.io/doc/user/options.html#'laststatus'
-- example why this is needed 1. open nvimtree 2. swap to buffer 3. swap back to nvimtree
vim.o.laststatus = 3

-- https://github.com/nvim-lualine/lualine.nvim
return {
    "nvim-lualine/lualine.nvim",
    lazy = true,
    event = "BufEnter", -- "VeryLazy" gives a bit of a delay on open before showing, so keeping at "BufEnter" for now
    dependencies = { "nvim-tree/nvim-web-devicons", opt = true },
    opts = {
        options = {
            -- themes: https://github.com/nvim-lualine/lualine.nvim/blob/master/THEMES.md
            theme = "material",
            refresh = {
                statusline = 100,
                tabline = 500,
                winbar = 300,
            },
            -- disabled_filetypes = { "NvimTree" },
        },
        -- not sure i prefer this to just disabling lualine when nvimtree is focused
        extensions = { "nvim-tree" },
        globalstatus = true,
        sections = {
            lualine_a = { { "mode", padding = 2 } },
            lualine_b = {
                "branch",
                "diff",
                "diagnostics",
                function()
                    if vim.b.disable_autoformat then
                        return "🚫 autoformat"
                    end
                    return ""
                end,
            },
            lualine_c = {
                -- set symbol based on state of buffer
                -- this functionality exists in the "filename".symbols object below this, however, the only option is to put this symbol AFTER the path
                -- i want the symbol BEFORE the path so it's in a consistent place for my eyes to look
                {
                    function()
                        local symbols = {}
                        if vim.fn.expand("%") == "" then
                            table.insert(symbols, "") -- unnamed
                        end
                        if vim.bo.modified then
                            table.insert(symbols, "") -- modified
                        end
                        if vim.bo.modifiable == false or vim.bo.readonly == true then
                            table.insert(symbols, "") -- readonly
                        end
                        if
                            vim.bo.buftype == ""
                            and vim.fn.filereadable(vim.fn.expand("%")) == 0
                            and vim.fn.expand("%") ~= ""
                        then
                            table.insert(symbols, "") -- newfile
                        end
                        return table.concat(symbols, "")
                    end,
                },
                {
                    "filename",
                    -- 0: Just the filename
                    -- 1: Relative path
                    -- 2: Absolute path
                    -- 3: Absolute path, with tilde as the home directory
                    -- 4: Filename and parent dir, with tilde as the home directory
                    path = 1,
                    symbols = {
                        modified = "", -- text to show when the file is modified.
                        readonly = "", -- text to show when the file is non-modifiable or readonly.
                        unnamed = "", -- text to show for unnamed buffers.
                        newfile = "", -- text to show for newly created file before first write.
                    },
                },
                -- notify if file has no EOL
                {
                    function()
                        return vim.bo.eol and "" or "[noeol]"
                    end,
                },
            },
            lualine_x = {
                {
                    require("gitblame").get_current_blame_text,
                },
                {
                    "searchcount",
                    maxcount = 9999,
                    timeout = 500,
                },
            },
            lualine_y = { "filetype" },
            lualine_z = {
                -- line count for current buffer
                function()
                    return vim.api.nvim_buf_line_count(0) .. " lines"
                end,
            },
        },
    },
}
