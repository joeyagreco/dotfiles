vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "requirements*.txt",
    callback = function()
        vim.bo.filetype = "requirements"
    end,
    desc = "Set filetype to requirements for files matching requirements*.txt",
})

-- set filetype to yaml for .yamlfmt files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.yamlfmt",
    callback = function()
        vim.bo.filetype = "yaml"
    end,
    desc = "Set filetype to yaml for .yamlfmt files",
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
