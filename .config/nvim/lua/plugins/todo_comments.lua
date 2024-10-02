-- https://github.com/folke/todo-comments.nvim
return {
    -- PERF: foo
    -- HACK: foo
    -- TODO: foo
    -- NOTE: foo
    -- FIXME: foo
    -- WARNING: foo
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = true,
    event = "BufEnter",
    -- https://github.com/folke/todo-comments.nvim?tab=readme-ov-file#%EF%B8%8F-configuration
    opts = {},
}
