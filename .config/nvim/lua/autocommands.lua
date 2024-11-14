-- set filetypes
local function set_filetype_autocmds(filetype_map)
    for filetype, patterns in pairs(filetype_map) do
        vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
            pattern = patterns,
            callback = function()
                vim.bo.filetype = filetype
            end,
            desc = "Set filetype to " .. filetype,
        })
    end
end

set_filetype_autocmds({
    requirements = { "requirements*.txt" },
    dosini = { ".shellcheckrc" },
    zsh = { ".macos" },
    json = { "*.swcrc*" },
    conf = { ".npmrc", ".nvmrc" },
    env = { ".env*" },
})

-- special cases for setting filetypes
-- set filetype for helm files
-- source: https://neovim.discourse.group/t/detect-helm-files-with-filetype-lua/3248
vim.filetype.add({
    pattern = {
        [".*/templates/.*%.yaml"] = "helm",
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
