-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-pick.md

-- USAGE
-- :Pick files tool='git'
-- :Pick grep_live
-- :Pick buffers
-- :Pick help

-- KEYMAPS (in picker)
-- <C-p>/<C-n> or arrows: move up/down
-- <Tab>: toggle preview
-- <S-Tab>: toggle info/help
-- <C-x>: mark current item
-- <C-a>: mark all matches
-- <CR>: choose item
-- <M-CR>: choose marked items
-- <C-Space>: refine matches
-- <Esc>: stop picker

return {
    "echasnovski/mini.pick",
    version = "*", -- stable
    lazy = true,
    cmd = "Pick",
    keys = {
        { "<leader>tf", "<cmd>Pick files<cr>", desc = "Find files" },
        { "<leader>ts", "<cmd>Pick grep_live<cr>", desc = "Live grep" },
        -- { "<leader>fb", "<cmd>Pick buffers<cr>", desc = "Find buffers" },
        { "<leader>th", "<cmd>Pick help<cr>", desc = "Find help" },
    },
    opts = {},
}
