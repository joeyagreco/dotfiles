-- set filetypes
vim.filetype.add({
    pattern = {
        [".*/templates/.*%.yaml"] = "helm", -- https://neovim.discourse.group/t/detect-helm-files-with-filetype-lua/3248
        ["requirements.*%.txt"] = "requirements",
        [".shellcheckrc"] = "dosini",
        ["%.swcrc"] = "json",
        [".npmrc"] = "conf",
        [".nvmrc"] = "conf",
        [".env.*"] = "env",
        ["Dockerfile.*"] = "dockerfile",
        ["gitignore.*"] = "gitignore",
        ["gitconfig.*"] = "gitconfig",
        ["*.zsh"] = "bash",
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
