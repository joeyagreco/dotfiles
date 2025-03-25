local M = {}

function M.setup()
    vim.api.nvim_create_user_command("TODO", function()
        print("Hello from commait!")
    end, {})
end

return M
