local helpers = require("helpers")

-- https://github.com/nvim-telescope/telescope.nvim
return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-live-grep-args.nvim",
        -- https://github.com/nvim-telescope/telescope-fzf-native.nvim
        -- NOTE: if seeing this error: "'fzf' extension doesn't exist or isn't installed"
        -- do this:
        -- cd ~/.local/share/nvim/lazy/telescope-fzf-native.nvim
        -- rm -rf build  # Remove any partially built files
        -- cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release
        -- cmake --build build --config Release
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
        },
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

        -- search nvim package files
        -- this is useful for finding the source code of plugin functions
        vim.api.nvim_create_user_command("Pack", function()
            telescope.extensions.live_grep_args.live_grep_args({ cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy") })
        end, { desc = "search nvim package files" })

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
            },
            extensions = {
                live_grep_args = {
                    mappings = {
                        i = {
                            ["<C-q>"] = lga_actions.quote_prompt(),
                            -- freeze the current list and start a fuzzy search in the frozen list
                            ["<C-r>"] = actions.to_fuzzy_refine,
                        },
                    },
                },
                fzf = {
                    fuzzy = true, -- false will only do exact matching
                    override_generic_sorter = true, -- override the generic sorter
                    override_file_sorter = true, -- override the file sorter
                    case_mode = "smart_case", -- or "ignore_case" or "respect_case"
                    -- the default case_mode is "smart_case"
                },
            },
        })

        ---------------------
        -- load extensions --
        ---------------------

        -- these MUST be loaded last
        telescope.load_extension("live_grep_args")
        telescope.load_extension("fzf")
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
            ":lua require('telescope.builtin').find_files()<CR>",
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
            ":lua require('telescope.builtin').lsp_document_symbols({symbols={'function', 'class', 'method', 'constructor', 'enum', 'interface', 'foo'}})<CR>",
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
