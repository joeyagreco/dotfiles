-- set filetype to requirements
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "requirements*.txt",
    callback = function()
        vim.bo.filetype = "requirements"
    end,
    desc = "Set filetype to requirements",
})

-- set filetype to yaml
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.yamlfmt",
    callback = function()
        vim.bo.filetype = "yaml"
    end,
    desc = "Set filetype to yaml",
})

-- set filetype to dosini
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = ".shellcheckrc",
    callback = function()
        vim.bo.filetype = "dosini"
    end,
    desc = "Set filetype to dosini",
})

-- set filetype to zsh
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = ".macos",
    callback = function()
        vim.bo.filetype = "zsh"
    end,
    desc = "set filetype to zsh",
})

-- highlight selection on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
    pattern = "*",
    desc = "Highlight selection on yank",
    callback = function()
        vim.highlight.on_yank({ timeout = 100, visual = true })
    end,
})

-- disable automatic comment insertion
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.opt_local.formatoptions:remove({ "c", "r", "o" })
    end,
})

-- clear command line after hitting <CR>
vim.api.nvim_create_autocmd("CmdlineLeave", {
    callback = function()
        vim.cmd("echo ''")
    end,
})
