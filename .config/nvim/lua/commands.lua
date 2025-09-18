-- show and copy to clipboard the pwd of the current buffer
vim.api.nvim_create_user_command("Pwd", function()
    local pwd = vim.fn.expand("%:p:h")
    vim.fn.setreg("+", pwd)
    print('"' .. pwd .. '" copied to clipboard')
end, { desc = "show and copy to clipboard the pwd of the current buffer" })

-- show and copy to clipboard the pwd of the current buffer relative to git root
vim.api.nvim_create_user_command("Pwdg", function()
    local full_path = vim.fn.expand("%:p:h")
    local git_root = vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", "")

    if vim.v.shell_error ~= 0 then
        print("error: not in a git repository")
        return
    end

    local relative_path = full_path:gsub("^" .. git_root:gsub("([%(%)%.%+%-%*%?%[%]%^%$%%])", "%%%1") .. "/", "")
    vim.fn.setreg("+", relative_path)
    print('"' .. relative_path .. '" copied to clipboard')
end, { desc = "show and copy to clipboard the pwd of the current buffer relative to git root" })

vim.api.nvim_create_user_command("Lsp", function()
    local attached_clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
    if #attached_clients == 0 then
        print("nothing attached")
    else
        local server_names = {}
        for _, client in ipairs(attached_clients) do
            table.insert(server_names, client.name)
        end
        print("attached: " .. table.concat(server_names, ", "))
    end
end, { desc = "print names of attached LSP servers" })

-- open up the current buffer's directory in the macos finder app
vim.api.nvim_create_user_command("Finder", function()
    local dir = vim.fn.expand("%:p:h")
    vim.fn.system({ "open", dir })
end, { desc = "open the current buffer's directory in finder" })

-- copy git-relative path to current buffer to clipboard with @{} format
-- NOTE: there's a bug where if you do a visual line selection with this command and then don't move the cursor and run it again it will still have the line selected
vim.api.nvim_create_user_command("Claude", function(opts)
    local full_path = vim.fn.expand("%:p")
    local git_root = vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", "")
    local relative_path = full_path:gsub("^" .. git_root:gsub("([%(%)%.%+%-%*%?%[%]%^%$%%])", "%%%1") .. "/", "")

    -- check for visual selection using range from opts
    local line_suffix = ""

    -- use visual marks directly since range doesn't work as expected
    local start_line = vim.fn.line("'<")
    local end_line = vim.fn.line("'>")
    local current_line = vim.fn.line(".")

    -- use visual marks if cursor is within selection range and it's not too far from current line
    -- this helps distinguish fresh selections from stale marks
    local max_distance = 10 -- adjust as needed
    if current_line >= start_line and current_line <= end_line and (end_line - start_line) <= max_distance then
        if start_line == end_line then
            line_suffix = "#L" .. start_line
        else
            line_suffix = "#L" .. start_line .. "-" .. end_line
        end
    end

    local clipboard_text = "@" .. relative_path .. line_suffix
    vim.fn.setreg("+", clipboard_text)
    print('"' .. clipboard_text .. '" copied to clipboard')
end, { desc = "copy git-relative path to current buffer to clipboard with @{} format", range = true })

vim.api.nvim_create_user_command(
    "Commit",
    function(opts)
        vim.cmd("GitBlameCopyCommitURL")
        print("commit url copied to clipboard")

        if opts.args and opts.args ~= "" then
            vim.cmd("GitBlameOpenCommitURL")
        end
    end,
    { desc = "copy commit url for commit that current line comes from. open as well with `:Commit open`", nargs = "?" }
)
