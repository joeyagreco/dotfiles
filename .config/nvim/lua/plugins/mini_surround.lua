-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-surround.md

-- ADD
-- sa{motion}{char}
-- DELETE
-- sd{char}
-- REPLACE
-- sr{target}{replacement}

return {
    "echasnovski/mini.surround",
    version = "*", -- stable
    opts = {
        -- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
        highlight_duration = 5000,

        -- Module mappings. Use `''` (empty string) to disable one.
        mappings = {
            add = "sa", -- Surround Add
            delete = "sd", -- Surround Delete
            replace = "sr", -- Surround Replace
            -- don't care about below ones
            find = "", -- Find surrounding (to the right)
            find_left = "", -- Find surrounding (to the left)
            highlight = "", -- Highlight surrounding
            update_n_lines = "", -- Update `n_lines`
            suffix_last = "", -- Suffix to search with "prev" method
            suffix_next = "", -- Suffix to search with "next" method
        },

        -- Number of lines within which surrounding is searched
        n_lines = 20,

        -- Whether to respect selection type:
        -- - Place surroundings on separate lines in linewise mode.
        -- - Place surroundings on each line in blockwise mode.
        respect_selection_type = false,

        -- How to search for surrounding (first inside current line, then inside
        -- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
        -- 'cover_or_nearest', 'next', 'prev', 'nearest'. For more details,
        -- see `:h MiniSurround.config`.
        search_method = "cover",

        -- Whether to disable showing non-error feedback
        -- This also affects (purely informational) helper messages shown after
        -- idle time if user input is required.
        silent = false,
    },
}
