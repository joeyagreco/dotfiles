-- https://github.com/folke/todo-comments.nvim
return {
    -- PERF: foo
    -- HACK: foo
    -- TODO: foo
    -- NOTE: foo
    -- FIXME: foo
    -- WARNING: foo
    -- IMPORTANT: foo
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = true,
    event = "VeryLazy",
    -- https://github.com/folke/todo-comments.nvim?tab=readme-ov-file#%EF%B8%8F-configuration
    opts = {
        keywords = {
            -- just adding "IMPORTANT", rest is default for "WARN"
            WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX", "IMPORTANT" } },
        },
    },
}
