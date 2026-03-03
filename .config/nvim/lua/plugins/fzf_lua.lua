-- https://github.com/ibhagwan/fzf-lua
-- used for live grep on large repos where telescope's lua-based
-- entry processing freezes the UI
return {
    "ibhagwan/fzf-lua",
    keys = {
        {
            "<leader>s",
            function()
                require("fzf-lua").live_grep({
                    fzf_opts = { ["--layout"] = "default" },
                    -- match telescope config: case insensitive, fixed strings, hidden files
                    rg_opts = "--column --line-number --no-heading --color=always --ignore-case --fixed-strings --hidden",
                    -- enable rg flags after "--" separator (e.g. "search term -- -tts")
                    rg_glob = true,
                    -- pass raw rg flags instead of converting to --iglob
                    rg_glob_fn = function(query, opts)
                        local search_query, flags = query:match("(.*)" .. opts.glob_separator .. "(.*)")
                        return search_query, flags
                    end,
                    keymap = {
                        fzf = {
                            -- append " -- " so you can start typing rg flags
                            ["ctrl-q"] = "transform-query(echo {q}' -- ')",
                        },
                    },
                })
            end,
            desc = "search for a word",
            silent = true,
            noremap = true,
        },
    },
}
