return {
    "nvim-telescope/telescope.nvim",
    lazy = true,
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
            ":lua require('telescope.builtin').lsp_document_symbols({symbols={'function', 'class', 'method', 'constructor', 'enum', 'interface'}})<CR>",
            desc = "find lsp symbols in the current file",
            silent = true,
            noremap = true,
        },
    },
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-live-grep-args.nvim" },
    config = function()
        local actions = require("telescope.actions")
        local lga_actions = require("telescope-live-grep-args.actions")
        local telescope = require("telescope")
        local previewers = require("telescope.previewers")

        local handle_large_files = function(filepath, bufnr, opts)
            -- size limit for previews (MB)
            local max_file_size_mb = 1
            local max_size = max_file_size_mb * 1024 * 1024
            vim.loop.fs_stat(filepath, function(_, stat)
                if not stat then
                    return
                end
                if stat.size > max_size then
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
                path_display = { "smart" },
                file_ignore_patterns = {
                    "build/",
                    "dist/",
                    "node_modules/",
                    ".git/",
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
            },
        })

        -- this must be last
        telescope.load_extension("live_grep_args")
    end,
}
