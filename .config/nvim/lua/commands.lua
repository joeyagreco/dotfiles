-- show and copy to clipboard the pwd of the current buffer
vim.api.nvim_create_user_command("Pwd", function()
    local pwd = vim.fn.expand("%:p:h")
    vim.fn.setreg("+", pwd)
    print('"' .. pwd .. '" copied to clipboard')
end, { desc = "show and copy to clipboard the pwd of the current buffer" })

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
vim.api.nvim_create_user_command("Claude", function()
    local full_path = vim.fn.expand("%:p")
    local git_root = vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", "")
    local relative_path = full_path:gsub("^" .. git_root:gsub("([%(%)%.%+%-%*%?%[%]%^%$%%])", "%%%1") .. "/", "")
    local clipboard_text = "@" .. relative_path
    vim.fn.setreg("+", clipboard_text)
    print('"' .. clipboard_text .. '" copied to clipboard')
end, { desc = "copy git-relative path to current buffer to clipboard with @{} format" })
