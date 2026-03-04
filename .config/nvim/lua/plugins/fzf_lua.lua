-- https://github.com/ibhagwan/fzf-lua

local rg_opts = "--column --line-number --no-heading --color=always --ignore-case --fixed-strings --hidden"

local function recent_files()
    local cwd = vim.fn.getcwd() .. "/"
    local current_file = vim.api.nvim_buf_get_name(0)
    local seen = {}
    local files = {}

    -- buffers sorted by last accessed time
    local bufinfos = vim.fn.getbufinfo({ buflisted = 1 })
    table.sort(bufinfos, function(a, b)
        return a.lastused > b.lastused
    end)
    for _, buf in ipairs(bufinfos) do
        local name = buf.name
        if name ~= "" and name ~= current_file and not seen[name] and vim.startswith(name, cwd) then
            table.insert(files, name)
            seen[name] = true
        end
    end

    -- append oldfiles not already in the buffer list
    for _, file in ipairs(vim.v.oldfiles) do
        local full = vim.fn.fnamemodify(file, ":p")
        if full ~= current_file and not seen[full] and vim.startswith(full, cwd) and vim.uv.fs_stat(full) then
            table.insert(files, full)
            seen[full] = true
        end
    end

    -- format entries with icons and relative paths
    local make_entry = require("fzf-lua.make_entry")
    local devicons = require("fzf-lua.devicons")
    devicons.load()
    local entry_opts = { cwd = vim.fn.getcwd(), file_icons = true, color_icons = true }
    local entries = {}
    for _, file in ipairs(files) do
        local entry = make_entry.file(file, entry_opts)
        if entry then
            table.insert(entries, entry)
        end
    end

    require("fzf-lua").fzf_exec(entries, {
        actions = require("fzf-lua").defaults.actions.files,
        previewer = "builtin",
        fzf_opts = { ["--no-sort"] = true, ["--ansi"] = true },
    })
end

return {
    "ibhagwan/fzf-lua",
    config = function()
        require("fzf-lua").setup({
            fzf_opts = { ["--layout"] = "default" },
            grep = { rg_opts = rg_opts },
        })
    end,
    init = function()
        vim.api.nvim_create_user_command("Keys", function()
            require("fzf-lua").keymaps({ winopts = { width = 0.6, height = 0.5 } })
        end, { desc = "see all keymaps" })

        vim.api.nvim_create_user_command("Commands", function()
            require("fzf-lua").commands({ winopts = { width = 0.6, height = 0.5 } })
        end, { desc = "see all commands" })
    end,
    keys = {
        {
            "<leader>s",
            function()
                require("fzf-lua").live_grep({
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
        {
            "<leader>f",
            function()
                require("fzf-lua").files({ cmd = "rg --files --hidden --glob '!.git/'" })
            end,
            desc = "find files",
            silent = true,
            noremap = true,
        },
        {
            "<leader>o",
            function()
                require("fzf-lua").resume()
            end,
            desc = "resume previous search",
            silent = true,
            noremap = true,
        },
        {
            "<leader>r",
            recent_files,
            desc = "recent files scoped to this directory",
            silent = true,
            noremap = true,
        },
        {
            "<leader>R",
            function()
                require("fzf-lua").oldfiles()
            end,
            desc = "recent files with no scope (show ALL recent files)",
            silent = true,
            noremap = true,
        },
        {
            "<leader>u",
            function()
                require("fzf-lua").lsp_references()
            end,
            desc = "find usages (references) for whatever the cursor is on",
            silent = true,
            noremap = true,
        },
        {
            "<leader>i",
            function()
                require("fzf-lua").lsp_document_symbols({
                    regex_filter = function(entry)
                        if not entry.text then
                            return true
                        end
                        local kind = entry.text:match("%[(.-)%]")
                        if not kind then
                            return false
                        end
                        local allowed = {
                            Function = true,
                            Class = true,
                            Method = true,
                            Constructor = true,
                            Enum = true,
                            Interface = true,
                        }
                        return allowed[kind] == true
                    end,
                })
            end,
            desc = "find lsp symbols in the current file",
            silent = true,
            noremap = true,
        },
        {
            "<leader>d",
            function()
                require("fzf-lua").diagnostics_document({
                    multiline = false,
                    cwd = vim.fn.expand("%:p:h"),
                    headers = false,
                })
            end,
            desc = "show lsp diagnostics for current buffer",
            silent = true,
            noremap = true,
        },
    },
}
