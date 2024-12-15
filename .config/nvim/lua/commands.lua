-- Open all LSP errors in the current buffer in the quickfix list
vim.api.nvim_create_user_command("Err", function()
    vim.diagnostic.setloclist({ open = true })
end, { desc = "open LSP errors in quickfix list" })

-- show and copy to clipboard the pwd of the current buffer
vim.api.nvim_create_user_command("Pwd", function()
    local pwd = vim.fn.expand("%:p:h")
    vim.fn.setreg("+", pwd)
    print('"' .. pwd .. '" copied to clipboard')
end, { desc = "show and copy to clipboard the pwd of the current buffer" })

vim.api.nvim_create_user_command("Lsp", function()
    local attached_clients = vim.lsp.get_active_clients({ bufnr = vim.api.nvim_get_current_buf() })
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
