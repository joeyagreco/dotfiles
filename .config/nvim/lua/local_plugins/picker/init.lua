-- custom picker using native neovim floating windows
local M = {}

local icons_ok, mini_icons = pcall(require, "mini.icons")

-- get file icon and highlight from mini.icons
local function get_icon(filename)
    if not icons_ok then
        return "", nil
    end
    local icon, hl = mini_icons.get("file", filename)
    return icon .. " ", hl
end

---@class PickerEntry
---@field filename string
---@field lnum number?
---@field col number?
---@field display string
---@field icon string?
---@field icon_hl string?

---@class PickerOpts
---@field title string
---@field search fun(query: string): PickerEntry[]
---@field on_select fun(entry: PickerEntry)
---@field preview fun(entry: PickerEntry, buf: number)?
---@field keymaps table<string, fun()>?

-- core picker that can be used by different sources
---@param opts PickerOpts
function M.open(opts)
    local results = {}
    local selected_idx = 1

    -- calculate dimensions
    local ui = vim.api.nvim_list_uis()[1]
    local total_width = math.floor(ui.width * 0.8)
    local total_height = math.floor(ui.height * 0.7)
    local left_width = math.floor(total_width * 0.4)
    local right_width = total_width - left_width - 1
    local input_height = 1
    local results_height = total_height - input_height - 2
    local start_row = math.floor((ui.height - total_height) / 2)
    local start_col = math.floor((ui.width - total_width) / 2)

    -- create input buffer and window
    local input_buf = vim.api.nvim_create_buf(false, true)
    vim.b[input_buf].minipairs_disable = true
    local input_win = vim.api.nvim_open_win(input_buf, true, {
        relative = "editor",
        width = left_width,
        height = input_height,
        row = start_row,
        col = start_col,
        style = "minimal",
        border = "rounded",
        title = " " .. opts.title .. " ",
        title_pos = "center",
    })

    -- create results buffer and window
    local results_buf = vim.api.nvim_create_buf(false, true)
    local results_win = vim.api.nvim_open_win(results_buf, false, {
        relative = "editor",
        width = left_width,
        height = results_height,
        row = start_row + input_height + 2,
        col = start_col,
        style = "minimal",
        border = "rounded",
        title = " Results ",
        title_pos = "center",
    })
    vim.api.nvim_set_option_value("cursorline", true, { win = results_win })

    -- create preview buffer and window
    local preview_buf = vim.api.nvim_create_buf(false, true)
    local preview_win = vim.api.nvim_open_win(preview_buf, false, {
        relative = "editor",
        width = right_width,
        height = total_height,
        row = start_row,
        col = start_col + left_width + 2,
        style = "minimal",
        border = "rounded",
        title = " Preview ",
        title_pos = "center",
    })

    local function close_all()
        pcall(vim.api.nvim_win_close, input_win, true)
        pcall(vim.api.nvim_win_close, results_win, true)
        pcall(vim.api.nvim_win_close, preview_win, true)
        pcall(vim.api.nvim_buf_delete, input_buf, { force = true })
        pcall(vim.api.nvim_buf_delete, results_buf, { force = true })
        pcall(vim.api.nvim_buf_delete, preview_buf, { force = true })
    end

    -- default file preview with line highlight
    local function default_preview(entry)
        if not entry or not entry.filename then
            vim.api.nvim_buf_set_lines(preview_buf, 0, -1, false, {})
            return
        end

        local ok, lines = pcall(vim.fn.readfile, entry.filename)
        if not ok then
            vim.api.nvim_buf_set_lines(preview_buf, 0, -1, false, { "Unable to read file" })
            return
        end

        local lnum = entry.lnum or 1
        local start_line = math.max(1, lnum - 5)
        local end_line = math.min(#lines, lnum + 5)
        local preview_lines = {}
        for i = start_line, end_line do
            table.insert(preview_lines, string.format("%4d: %s", i, lines[i] or ""))
        end

        vim.api.nvim_buf_set_lines(preview_buf, 0, -1, false, preview_lines)

        -- set filetype for syntax highlighting
        local ft = vim.filetype.match({ filename = entry.filename })
        if ft then
            pcall(vim.api.nvim_set_option_value, "filetype", ft, { buf = preview_buf })
        end

        -- highlight the match line
        if entry.lnum then
            local ns = vim.api.nvim_create_namespace("picker_preview_match")
            vim.api.nvim_buf_clear_namespace(preview_buf, ns, 0, -1)
            local match_line_idx = lnum - start_line
            if match_line_idx >= 0 and match_line_idx < #preview_lines then
                vim.api.nvim_buf_set_extmark(preview_buf, ns, match_line_idx, 0, {
                    end_col = #preview_lines[match_line_idx + 1],
                    hl_group = "CursorLine",
                    hl_eol = true,
                })
            end
        end
    end

    local function update_preview()
        if #results == 0 or selected_idx < 1 or selected_idx > #results then
            vim.api.nvim_buf_set_lines(preview_buf, 0, -1, false, {})
            return
        end

        local entry = results[selected_idx]
        if opts.preview then
            opts.preview(entry, preview_buf)
        else
            default_preview(entry)
        end
    end

    local function update_selection()
        if not vim.api.nvim_win_is_valid(results_win) then
            return
        end
        if #results > 0 and selected_idx >= 1 and selected_idx <= #results then
            vim.api.nvim_win_set_cursor(results_win, { selected_idx, 0 })
        end
        update_preview()
    end

    local function render_results()
        local display_lines = {}
        for _, entry in ipairs(results) do
            table.insert(display_lines, entry.display)
        end

        vim.api.nvim_buf_set_lines(results_buf, 0, -1, false, display_lines)

        -- apply icon highlights
        local ns = vim.api.nvim_create_namespace("picker_icons")
        vim.api.nvim_buf_clear_namespace(results_buf, ns, 0, -1)
        for i, entry in ipairs(results) do
            if entry.icon_hl and entry.icon then
                vim.api.nvim_buf_set_extmark(results_buf, ns, i - 1, 0, {
                    end_col = #entry.icon,
                    hl_group = entry.icon_hl,
                })
            end
        end
    end

    local function do_search(query)
        if not query or query == "" then
            results = {}
            vim.api.nvim_buf_set_lines(results_buf, 0, -1, false, {})
            vim.api.nvim_buf_set_lines(preview_buf, 0, -1, false, {})
            return
        end

        results = opts.search(query)
        render_results()
        selected_idx = 1
        update_selection()
    end

    local function open_selected()
        if #results == 0 or selected_idx < 1 or selected_idx > #results then
            return
        end
        local entry = results[selected_idx]
        close_all()
        opts.on_select(entry)
    end

    -- set up input buffer as prompt
    vim.api.nvim_set_option_value("buftype", "prompt", { buf = input_buf })
    vim.fn.prompt_setprompt(input_buf, "> ")

    vim.api.nvim_buf_attach(input_buf, false, {
        on_lines = function()
            vim.schedule(function()
                if not vim.api.nvim_buf_is_valid(input_buf) then
                    return
                end
                local lines = vim.api.nvim_buf_get_lines(input_buf, 0, 1, false)
                local query = (lines[1] or ""):gsub("^> ", "")
                do_search(query)
            end)
        end,
    })

    -- keymaps
    local kopts = { buffer = input_buf, noremap = true, silent = true }

    vim.keymap.set({ "i", "n" }, "<Esc>", close_all, kopts)
    vim.keymap.set("i", "<CR>", open_selected, kopts)

    vim.keymap.set("i", "<C-n>", function()
        if selected_idx < #results then
            selected_idx = selected_idx + 1
            update_selection()
        end
    end, kopts)

    vim.keymap.set("i", "<C-p>", function()
        if selected_idx > 1 then
            selected_idx = selected_idx - 1
            update_selection()
        end
    end, kopts)

    vim.keymap.set("i", "<Down>", function()
        if selected_idx < #results then
            selected_idx = selected_idx + 1
            update_selection()
        end
    end, kopts)

    vim.keymap.set("i", "<Up>", function()
        if selected_idx > 1 then
            selected_idx = selected_idx - 1
            update_selection()
        end
    end, kopts)

    -- quote the current search
    vim.keymap.set("i", "<C-q>", function()
        local lines = vim.api.nvim_buf_get_lines(input_buf, 0, 1, false)
        local query = (lines[1] or ""):gsub("^> ", "")
        vim.api.nvim_buf_set_lines(input_buf, 0, 1, false, { '> "' .. query .. '" ' })
        vim.api.nvim_win_set_cursor(input_win, { 1, #('> "' .. query .. '" ') })
    end, kopts)

    -- custom keymaps from opts
    if opts.keymaps then
        for key, fn in pairs(opts.keymaps) do
            vim.keymap.set("i", key, fn, kopts)
        end
    end

    vim.cmd("startinsert!")
end

-- helper to parse rg-style flags from query
function M.parse_query_with_flags(query)
    local search_term = query:match("^%s*(.-)%s*$")
    local flags = {}
    local pattern = search_term

    -- check for flags after quoted string
    local quoted_match = search_term:match("^([\"'].+[\"'])%s+(%-[%w%-]+.*)$")
    if quoted_match then
        pattern = quoted_match
        local flags_str = search_term:match("^[\"'].+[\"']%s+(%-[%w%-]+.*)$")
        if flags_str then
            for flag in flags_str:gmatch("%-[%w%-]+") do
                table.insert(flags, flag)
            end
        end
    else
        local unquoted_match = search_term:match("^(.-)%s+(%-[%w%-]+.*)$")
        if unquoted_match then
            pattern = unquoted_match
            local flags_str = search_term:match("^.-%s+(%-[%w%-]+.*)$")
            if flags_str then
                for flag in flags_str:gmatch("%-[%w%-]+") do
                    table.insert(flags, flag)
                end
            end
        end
    end

    -- strip quotes
    if pattern:match('^".*"$') then
        pattern = pattern:match('^"(.-)"$') or pattern
    elseif pattern:match("^'.*'$") then
        pattern = pattern:match("^'(.-)'$") or pattern
    end

    return pattern, flags
end

-- grep source
function M.live_grep()
    M.open({
        title = "Grep",
        search = function(query)
            local pattern, flags = M.parse_query_with_flags(query)

            local cmd = {
                "rg",
                "--color=never",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column",
                "--ignore-case",
                "--fixed-strings",
                "--hidden",
                "--glob",
                "!.git",
            }

            for _, flag in ipairs(flags) do
                table.insert(cmd, flag)
            end
            table.insert(cmd, pattern)

            local output = vim.fn.systemlist(cmd)
            local entries = {}
            local max_results = 100

            for _, line in ipairs(output) do
                if #entries >= max_results then
                    break
                end
                local filename, lnum, col, text = line:match("^(.+):(%d+):(%d+):(.*)$")
                if filename then
                    local icon, hl = get_icon(filename)
                    table.insert(entries, {
                        filename = filename,
                        lnum = tonumber(lnum),
                        col = tonumber(col),
                        text = text,
                        icon = icon,
                        icon_hl = hl,
                        display = string.format("%s%s:%s:%s", icon, filename, lnum, text),
                    })
                end
            end

            return entries
        end,
        on_select = function(entry)
            vim.cmd("edit " .. vim.fn.fnameescape(entry.filename))
            vim.api.nvim_win_set_cursor(0, { entry.lnum, entry.col - 1 })
            vim.cmd("normal! zz")
        end,
    })
end

function M.setup()
    vim.keymap.set("n", "<leader>ts", M.live_grep, { desc = "custom live grep picker", silent = true })
end

return M
