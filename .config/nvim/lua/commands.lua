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
-- if no visual selection, will copy current file like @foo/bar.py
-- if visual selection for a single line, will copy current file and visual selection like @foo/bar.py#L9
-- if visual selection for multiple lines, will copy current file and visual selection like @foo/bar.py#L18-24
-- will print something like '"@foo/bar.py#L8" copied to clipboard'
vim.api.nvim_create_user_command("Claude", function(opts)
    local full_path = vim.fn.expand("%:p")
    local git_root = vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", "")

    if vim.v.shell_error ~= 0 then
        print("error: not in a git repository")
        return
    end

    local relative_path = full_path:gsub("^" .. git_root:gsub("([%(%)%.%+%-%*%?%[%]%^%$%%])", "%%%1") .. "/", "")
    local result = "@" .. relative_path

    -- handle visual selection
    if opts.range == 2 then
        local start_line = opts.line1
        local end_line = opts.line2

        if start_line == end_line then
            result = result .. "#L" .. start_line
        else
            result = result .. "#L" .. start_line .. "-" .. end_line
        end
    end

    vim.fn.setreg("+", result)
    print('"' .. result .. '" copied to clipboard')
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
