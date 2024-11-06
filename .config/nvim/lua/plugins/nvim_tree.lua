-- disable netrw for nvim-tree
-- :help nvim-tree-netrw
-- https://github.com/nvim-tree/nvim-tree.lua?tab=readme-ov-file#install
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local constants = require("constants")

return {
    "nvim-tree/nvim-tree.lua",
    lazy = true,
    keys = {
        {
            "<leader>e",
            ":lua require('nvim-tree.api').tree.open({focus = true})<CR>",
            desc = "toggle / focus on explorer",
            silent = true,
            noremap = true,
        },
    },
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    opts = {
        sort = {
            sorter = "case_sensitive",
        },
        view = {
            width = 40,
        },
        actions = {
            open_file = {
                quit_on_open = true,
            },
        },
        renderer = {
            group_empty = true,
            icons = {
                glyphs = {
                    git = {
                        unstaged = "✷",
                        staged = "✓",
                        unmerged = "",
                        renamed = "➜",
                        untracked = "✩",
                        deleted = "✗",
                        ignored = "◌",
                    },
                },
            },
        },
        update_focused_file = {
            enable = true,
            update_cwd = true,
            update_root = true,
        },
        -- set all local git directories as root dirs
        root_dirs = constants.ALL_LOCAL_GIT_REPO_PATHS,
        -- auto update tree based on cwd
        -- this allows us to just change the cwd and see the tree update automatically
        hijack_directories = {
            enable = true,
            auto_open = true,
        },
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        filters = {
            enable = true,
            git_ignored = true,
            dotfiles = false,
            git_clean = false,
            no_buffer = false,
            no_bookmark = false,
            -- always show these files in the tree
            exclude = { ".env" },
        },
    },
    -- idk if this is needed
    -- config = function()
    --     -- https://github.com/nvim-tree/nvim-tree.lua/blob/12a9a995a455d2c2466e47140663275365a5d2fc/doc/nvim-tree-lua.txt#L376
    --     local constants = require("constants")
    --     local nvim_tree = require("nvim-tree")
    --
    --     nvim_tree.root_dirs = constants.ALL_LOCAL_GIT_REPO_PATHS
    -- end,
}
