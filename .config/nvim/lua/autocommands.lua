-- set filetypes
vim.filetype.add({
    extension = {
        j2 = "jinja",
    },
    pattern = {
        [".*/templates/.*%.yaml"] = "helm", -- https://neovim.discourse.group/t/detect-helm-files-with-filetype-lua/3248
        ["requirements.*%.txt"] = "requirements",
        [".shellcheckrc"] = "dosini",
        ["%.swcrc"] = "json",
        [".npmrc"] = "conf",
        [".nvmrc"] = "conf",
        [".eslintignore"] = "gitignore",
        [".*/%.env.*"] = "env", -- matches .env, .env.foo
        [".*/.*%.env"] = "env", -- matches foo.env
        ["Dockerfile.*"] = "dockerfile",
        ["gitignore.*"] = "gitignore",
        ["gitconfig.*"] = "gitconfig",
        [".*/.*%.zsh"] = "bash",
    },
})

-- highlight selection on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
    pattern = "*",
    desc = "highlight selection on yank",
    callback = function()
        vim.hl.on_yank({ timeout = 100, visual = true })
    end,
})

-- disable automatic comment insertion
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    desc = "disable automatic comment insertion",
    callback = function()
        vim.opt_local.formatoptions:remove({ "c", "r", "o" })
    end,
})

-- clear command line after hitting <CR>
vim.api.nvim_create_autocmd("CmdlineLeave", {
    desc = "clear command line after hitting <CR>",
    callback = function()
        vim.cmd("echo ''")
    end,
})

-- define comment strings for various filetypes
local commentstrings = {
    openscad = "// %s",
    env = "# %s",
    proto = "// %s",
    gomod = "// %s",
    javascriptreact = "{/* %s */}",
}

for ft, cs in pairs(commentstrings) do
    vim.api.nvim_create_autocmd("FileType", {
        pattern = ft,
        callback = function()
            vim.bo.commentstring = cs
        end,
    })
end

-- force-kill lsp servers on quit to prevent slow shutdown
vim.api.nvim_create_autocmd("VimLeavePre", {
    desc = "force stop all lsp clients on quit",
    callback = function()
        vim.lsp.stop_client(vim.lsp.get_clients(), true)
    end,
})

-- restore cursor position to where it was when reopening a file
-- this will persist across restarts of nvim
vim.api.nvim_create_autocmd("BufReadPost", {
    desc = "restore cursor position when reopening a file",
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local line_count = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= line_count then
            vim.api.nvim_win_set_cursor(0, mark)
        end
    end,
})
