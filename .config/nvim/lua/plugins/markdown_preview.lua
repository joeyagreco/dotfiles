-- NOTE: may have to do this if not working:
-- cd /Users/joeyagreco/.local/share/nvim/lazy/markdown-preview.nvim/app
-- npm install tslib
return {
    "iamcco/markdown-preview.nvim",
    cmd = { "Mark" },
    build = "cd app && yarn install",
    init = function()
        vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
    config = function()
        -- preview current markdown file in browser
        vim.api.nvim_create_user_command("Mark", function()
            vim.cmd("MarkdownPreview")
        end, { desc = "preview current markdown file in browser" })
    end,
}
