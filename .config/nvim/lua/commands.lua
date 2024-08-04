-- Open all LSP errors in the current buffer in the quickfix list
vim.api.nvim_create_user_command("Errors", function()
	vim.diagnostic.setloclist({ open = true })
end, { desc = "Open LSP errors in quickfix list" })

-- open git dif view
vim.api.nvim_create_user_command("Dif", "DiffviewOpen", { desc = "Open DiffView" })
