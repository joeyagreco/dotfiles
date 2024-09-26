-- Open all LSP errors in the current buffer in the quickfix list
vim.api.nvim_create_user_command("Err", function()
    vim.diagnostic.setloclist({ open = true })
end, { desc = "Open LSP errors in quickfix list" })

-- show and copy to clipboard the pwd of the current buffer
vim.api.nvim_create_user_command("Pwd", function()
    local pwd = vim.fn.expand("%:p:h")
    vim.fn.setreg("+", pwd)
    print(pwd)
end, { desc = "show and copy to clipboard the pwd of the current buffer" })

-- copy url of current line in git
vim.api.nvim_create_user_command("Url", function()
    vim.cmd("GitBlameCopyFileURL")
    print("git url copied")
end, { desc = "copy url of current line in git" })
