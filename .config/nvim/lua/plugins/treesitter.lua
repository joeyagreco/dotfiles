-- https://github.com/nvim-treesitter/nvim-treesitter
return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter").setup()

        local parsers = { "go", "gomod", "python", "typescript", "javascript", "terraform", "css" }
        require("nvim-treesitter").install(parsers)

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "*",
            callback = function()
                pcall(vim.treesitter.start)
            end,
        })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "*",
            callback = function()
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })
    end,
}
