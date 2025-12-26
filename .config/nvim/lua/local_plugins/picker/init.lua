-- custom picker using native neovim floating windows
local M = {}

function M.live_grep()
    local results = {}
    local selected_idx = 1

    -- calculate dimensions
    local ui = vim.api.nvim_list_uis()[1]
    local total_width = math.floor(ui.width * 0.8)
    local total_height = math.floor(ui.height * 0.7)
    local left_width = math.floor(total_width * 0.4)
    local right_width = total_width - left_width - 1 -- -1 for gap
    local input_height = 1
    local results_height = total_height - input_height - 2 -- -2 for border gap
    local start_row = math.floor((ui.height - total_height) / 2)
    local start_col = math.floor((ui.width - total_width) / 2)

    -- create input buffer and window (top left)
    local input_buf = vim.api.nvim_create_buf(false, true)
    local input_win = vim.api.nvim_open_win(input_buf, true, {
        relative = "editor",
        width = left_width,
        height = input_height,
        row = start_row,
        col = start_col,
        style = "minimal",
        border = "rounded",
        title = " Search ",
        title_pos = "center",
    })

    -- create results buffer and window (bottom left, below input)
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

    -- create preview buffer and window (right side, full height)
    local preview_buf = vim.api.nvim_create_buf(false, true)
    local preview_win = vim.api.nvim_open_win(preview_buf, false, {
        relative = "editor",
        width = right_width,
        height = total_height,
        row = start_row,
        col = start_col + left_width + 2, -- +2 for gap
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

    local function update_preview()
        if #results == 0 or selected_idx < 1 or selected_idx > #results then
            vim.api.nvim_buf_set_lines(preview_buf, 0, -1, false, {})
            return
        end

        local entry = results[selected_idx]
        if not entry or not entry.filename then
            return
        end

        -- read file and show context around the match line
        local ok, lines = pcall(vim.fn.readfile, entry.filename)
        if not ok then
            vim.api.nvim_buf_set_lines(preview_buf, 0, -1, false, { "Unable to read file" })
            return
        end

        local start_line = math.max(1, entry.lnum - 5)
        local end_line = math.min(#lines, entry.lnum + 5)
        local preview_lines = {}
        for i = start_line, end_line do
            table.insert(preview_lines, string.format("%4d: %s", i, lines[i] or ""))
        end

        vim.api.nvim_buf_set_lines(preview_buf, 0, -1, false, preview_lines)

        -- try to set filetype for syntax highlighting
        local ft = vim.filetype.match({ filename = entry.filename })
        if ft then
            pcall(vim.api.nvim_set_option_value, "filetype", ft, { buf = preview_buf })
        end

        -- highlight the match line
        local ns = vim.api.nvim_create_namespace("picker_preview_match")
        vim.api.nvim_buf_clear_namespace(preview_buf, ns, 0, -1)
        local match_line_idx = entry.lnum - start_line -- 0-indexed
        if match_line_idx >= 0 and match_line_idx < #preview_lines then
            vim.api.nvim_buf_set_extmark(preview_buf, ns, match_line_idx, 0, {
                end_col = #preview_lines[match_line_idx + 1],
                hl_group = "CursorLine",
                hl_eol = true,
            })
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

    local icons_ok, mini_icons = pcall(require, "mini.icons")

    local function do_search(query)
        if not query or query == "" then
            results = {}
            vim.api.nvim_buf_set_lines(results_buf, 0, -1, false, {})
            vim.api.nvim_buf_set_lines(preview_buf, 0, -1, false, {})
            return
        end

        -- trim whitespace
        local search_term = query:match("^%s*(.-)%s*$")

        -- parse rg flags from query (e.g., "foo" -tpy -> pattern="foo", flags="-tpy")
        local flags = {}
        local pattern = search_term

        -- check for flags after quoted string: "pattern" -flags
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
            -- check for flags after unquoted pattern: pattern -flags
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

        -- handle quoted strings - strip quotes for literal search
        if pattern:match('^".*"$') then
            pattern = pattern:match('^"(.-)"$') or pattern
        elseif pattern:match("^'.*'$") then
            pattern = pattern:match("^'(.-)'$") or pattern
        end

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

        -- add user flags
        for _, flag in ipairs(flags) do
            table.insert(cmd, flag)
        end

        -- add search pattern
        table.insert(cmd, pattern)

        local output = vim.fn.systemlist(cmd)
        results = {}

        local max_results = 100
        for _, line in ipairs(output) do
            if #results >= max_results then
                break
            end
            local filename, lnum, col, text = line:match("^(.+):(%d+):(%d+):(.*)$")
            if filename then
                local icon, hl = "", nil
                if icons_ok then
                    icon, hl = mini_icons.get("file", filename)
                    icon = icon .. " "
                end
                table.insert(results, {
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

        local display_lines = {}
        for _, entry in ipairs(results) do
            table.insert(display_lines, entry.display)
        end

        vim.api.nvim_buf_set_lines(results_buf, 0, -1, false, display_lines)

        -- apply icon highlights
        local ns = vim.api.nvim_create_namespace("picker_icons")
        vim.api.nvim_buf_clear_namespace(results_buf, ns, 0, -1)
        for i, entry in ipairs(results) do
            if entry.icon_hl then
                vim.api.nvim_buf_set_extmark(results_buf, ns, i - 1, 0, {
                    end_col = #entry.icon,
                    hl_group = entry.icon_hl,
                })
            end
        end

        selected_idx = 1
        update_selection()
    end

    local function open_selected()
        if #results == 0 or selected_idx < 1 or selected_idx > #results then
            return
        end

        local entry = results[selected_idx]
        close_all()

        vim.cmd("edit " .. vim.fn.fnameescape(entry.filename))
        vim.api.nvim_win_set_cursor(0, { entry.lnum, entry.col - 1 })
        vim.cmd("normal! zz")
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
                local query = lines[1] or ""
                -- remove prompt prefix
                query = query:gsub("^> ", "")
                do_search(query)
            end)
        end,
    })

    -- keymaps
    local kopts = { buffer = input_buf, noremap = true, silent = true }

    -- close on escape
    vim.keymap.set({ "i", "n" }, "<Esc>", close_all, kopts)

    -- navigate results
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

    -- open selected
    vim.keymap.set("i", "<CR>", open_selected, kopts)

    -- quote the current search
    vim.keymap.set("i", "<C-q>", function()
        local lines = vim.api.nvim_buf_get_lines(input_buf, 0, 1, false)
        local query = (lines[1] or ""):gsub("^> ", "")
        vim.api.nvim_buf_set_lines(input_buf, 0, 1, false, { '> "' .. query .. '" ' })
        -- move cursor to end
        vim.api.nvim_win_set_cursor(input_win, { 1, #('> "' .. query .. '" ') })
    end, kopts)

    -- start in insert mode
    vim.cmd("startinsert!")
end

function M.setup()
    vim.keymap.set("n", "<leader>ts", M.live_grep, { desc = "custom live grep picker", silent = true })
end

return M
