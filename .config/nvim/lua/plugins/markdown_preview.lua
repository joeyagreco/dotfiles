-- NOTE: may have to do this if not working:
-- cd /Users/joeyagreco/.local/share/nvim/lazy/markdown-preview.nvim/app
-- npm install tslib
return {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
        vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
}
