local helpers = require("helpers")

-- https://github.com/nvim-telescope/telescope.nvim
return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-live-grep-args.nvim",
    },
    priority = helpers.plugin_priority.TELESCOPE,
    lazy = false,
    tag = "0.1.8",
    config = function()
        local actions = require("telescope.actions")
        local lga_actions = require("telescope-live-grep-args.actions")
        local telescope = require("telescope")
        local previewers = require("telescope.previewers")
        local builtin = require("telescope.builtin")

        -----------------------
        -- set user commands --
        -----------------------

        -- see all keymaps
        vim.api.nvim_create_user_command("Keys", function()
            builtin.keymaps({
                layout_strategy = "horizontal",
                layout_config = { width = 0.6, height = 0.5 },
                sorting_strategy = "ascending",
                prompt_title = "🔑 Keymaps",
            })
        end, { desc = "see all keymaps" })

        vim.api.nvim_create_user_command("Commands", function()
            builtin.commands({
                layout_strategy = "horizontal",
                layout_config = { width = 0.6, height = 0.5 },
                sorting_strategy = "ascending",
                prompt_title = "⚡ Commands",
            })
        end, { desc = "see all commands" })

        -- search nvim package / plugin files
        -- this is useful for finding the source code of plugin functions
        vim.api.nvim_create_user_command("Pack", function()
            telescope.extensions.live_grep_args.live_grep_args({ cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy") })
        end, { desc = "search nvim package / plugin files" })

        local handle_large_files = function(filepath, bufnr, opts)
            -- size limit for previews (kb)
            local max_file_size_kb = 100
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
                -- better than smart because this allows me to see the path enough to differentiate from things like:
                -- "one/foo/bar/baz/main.py"
                -- "two/foo/bar/baz/main.py"
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
            extensions = {
                live_grep_args = {
                    mappings = {
                        i = {
                            ["<C-q>"] = lga_actions.quote_prompt(),
                        },
                    },
                },
            },
        })

        ---------------------
        -- load extensions --
        ---------------------

        -- these MUST be loaded last
        telescope.load_extension("live_grep_args")
    end,
    keys = {
        {
            "<leader>s",
            ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
            -- https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md
            desc = "search for a word",
            silent = true,
            noremap = true,
        },
        {
            "<leader>f",
            -- old way of doing this: ":lua require('telescope.builtin').find_files()<CR>",
            -- new way of doing this to match how we search with <leader>s (with quoting keymaps and rg flag search)
            function()
                local pickers = require("telescope.pickers")
                local finders = require("telescope.finders")
                local conf = require("telescope.config").values
                local make_entry = require("telescope.make_entry")
                local action_state = require("telescope.actions.state")

                pickers
                    .new({}, {
                        prompt_title = "Find Files (Args)",
                        finder = finders.new_dynamic({
                            entry_maker = make_entry.gen_from_file({}),
                            fn = function(prompt)
                                if not prompt or prompt == "" then
                                    return vim.fn.systemlist("rg --files --hidden")
                                end

                                -- parse rg flags from prompt (e.g., "deps -tpy" -> pattern="deps", flags="-tpy")
                                local pattern = prompt
                                local flags = ""
                                local flag_match = prompt:match("(.-)%s+(%-[%w%-]+.*)$")
                                if flag_match then
                                    pattern = flag_match
                                    flags = prompt:match("^.-%s+(%-[%w%-]+.*)$")
                                end

                                -- if pattern is already quoted, don't shellescape it
                                local pattern_arg
                                if pattern:match('^".*"$') or pattern:match("^'.*'$") then
                                    pattern_arg = pattern
                                else
                                    pattern_arg = vim.fn.shellescape(pattern)
                                end

                                local cmd = "rg --files --hidden "
                                    .. flags
                                    .. " 2>/dev/null | rg --ignore-case "
                                    .. pattern_arg
                                    .. " 2>/dev/null"
                                local results = vim.fn.systemlist(cmd)
                                -- return empty list if command failed
                                if vim.v.shell_error ~= 0 then
                                    return {}
                                end
                                return results
                            end,
                        }),
                        previewer = conf.file_previewer({}),
                        sorter = require("telescope.sorters").empty(),
                        attach_mappings = function(prompt_bufnr, map)
                            -- quote the entire prompt
                            map("i", "<C-q>", function()
                                local current_picker = action_state.get_current_picker(prompt_bufnr)
                                local prompt_text = current_picker:_get_prompt()
                                current_picker:set_prompt('"' .. prompt_text .. '" ')
                            end)
                            return true
                        end,
                    })
                    :find()
            end,
            desc = "find files",
            silent = true,
            noremap = true,
        },
        {
            "<leader>o",
            ":lua require('telescope.builtin').resume()<CR>",
            desc = "resume previous search",
            silent = true,
            noremap = true,
        },
        {
            "<leader>r",
            ":lua require('telescope.builtin').oldfiles({ cwd = vim.fn.getcwd() })<CR>",
            desc = "toggle recent files scoped to this directory",
            silent = true,
            noremap = true,
        },
        {
            "<leader>R",
            ":lua require('telescope.builtin').oldfiles()<CR>",
            desc = "toggle recent files with no scope (show ALL recent files)",
            silent = true,
            noremap = true,
        },
        {
            "<leader>u",
            ":lua require('telescope.builtin').lsp_references()<CR>",
            desc = "find usages (references) for whatever the cursor is on",
            silent = true,
            noremap = true,
        },
        {
            "<leader>i",
            -- symbols are defined here starting on line 556: https://mlir.llvm.org/doxygen/include_2mlir_2Tools_2lsp-server-support_2Protocol_8h_source.html
            ":lua require('telescope.builtin').lsp_document_symbols({symbols={'function', 'class', 'method', 'constructor', 'enum', 'interface'}})<CR>",
            desc = "find lsp symbols in the current file",
            silent = true,
            noremap = true,
        },
        {
            "<leader>d",
            ":lua require('telescope.builtin').diagnostics({ bufnr=0 })<CR>",
            desc = "show lsp diagnostics for current buffer",
            silent = true,
            noremap = true,
        },
    },
}
