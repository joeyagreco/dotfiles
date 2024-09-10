-- Open all LSP errors in the current buffer in the quickfix list
vim.api.nvim_create_user_command("Err", function()
	vim.diagnostic.setloclist({ open = true })
end, { desc = "Open LSP errors in quickfix list" })

-- open git dif view
vim.api.nvim_create_user_command("Dif", "DiffviewOpen", { desc = "Open DiffView" })

-- open merge conflicts in quickfix list
-- mappings in plugin/git_conflict.lua
vim.api.nvim_create_user_command("Con", "GitConflictListQf", { desc = "open merge conflicts in quickfix list" })

-- show and copy to clipboard the pwd of the current buffer
vim.api.nvim_create_user_command("Pwd", function()
	local pwd = vim.fn.expand("%:p:h")
	vim.fn.setreg("+", pwd) -- Copy to system clipboard
	print(pwd)
end, { desc = "Show and copy to clipboard the pwd of the current buffer" })
