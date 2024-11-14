-- set filetypes
vim.filetype.add({
    pattern = {
        [".*/templates/.*%.yaml"] = "helm", -- https://neovim.discourse.group/t/detect-helm-files-with-filetype-lua/3248
        ["requirements.*%.txt"] = "requirements",
        [".shellcheckrc"] = "dosini",
        [".macos"] = "zsh",
        ["%.swcrc"] = "json",
        [".npmrc"] = "conf",
        [".nvmrc"] = "conf",
        [".env.*"] = "env",
    },
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
