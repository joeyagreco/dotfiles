local helpers = require("helpers")

-- https://github.com/nvim-telescope/telescope.nvim
return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    priority = helpers.plugin_priority.TELESCOPE,
    lazy = true,
    tag = "v0.2.1",
    config = function()
        local actions = require("telescope.actions")
        local telescope = require("telescope")
        local previewers = require("telescope.previewers")

        local handle_large_files = function(filepath, bufnr, opts)
            -- size limit for previews (kb)
            local max_file_size_kb = 200
            local max_size_bytes = max_file_size_kb * 1024
            vim.loop.fs_stat(filepath, function(_, stat)
                if not stat then
                    return
                end
                if stat.size > max_size_bytes then
                    -- skip showing preview
                    return
                else
                    previewers.buffer_previewer_maker(filepath, bufnr, opts)
                end
            end)
        end
        telescope.setup({
            defaults = {
                -- don't show preview for large files
                buffer_previewer_maker = handle_large_files,
                -- used to use truncate which i believed to be better than smart because this allows me to see the path enough to differentiate from things like:
                -- "one/foo/bar/baz/main.py"
                -- "two/foo/bar/baz/main.py"
                -- HOWEVER, for long paths i need to see the end instead of the start of the path
                path_display = { "truncate" },
                file_ignore_patterns = {
                    -- removing this for now as fx in golang uses "/build" folders a lot and we do not want telescope to ignore those
                    -- "build/",
                    "dist/",
                    "node_modules/",
                    "^.git/",
                },
                hidden = true,
                vimgrep_arguments = {
                    "rg",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--ignore-case",
                    "--fixed-strings",
                    "--hidden", -- Include hidden files
                },
                mappings = {
                    i = {
                        ["<esc>"] = actions.close,
                    },
                },
            },
            pickers = {
                find_files = {
                    hidden = true,
                },
                commands = {
                    entry_maker = function(entry)
                        local make_entry = require("telescope.make_entry")
                        local default_entry = make_entry.gen_from_commands({})(entry)

                        -- add description to ordinal for searching
                        local desc = ""
                        if entry.definition and entry.definition.desc then
                            desc = " " .. entry.definition.desc
                        end
                        default_entry.ordinal = entry.name .. desc

                        return default_entry
                    end,
                },
            },
        })
    end,
}
