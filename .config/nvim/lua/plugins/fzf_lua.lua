-- https://github.com/ibhagwan/fzf-lua
return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = true,
    keys = {
        {
            "<leader>s",
            ":lua require('fzf-lua').live_grep()<CR>",
            desc = "Search with filetype filtering and max results per file",
            silent = true,
            noremap = true,
        },
        {
            "<leader>f",
            ":lua require('fzf-lua').files()<CR>",
            desc = "find files",
            silent = true,
            noremap = true,
        },
        {
            "<leader>o",
            ":lua require('fzf-lua').resume()<CR>",
            desc = "resume previous search",
            silent = true,
            noremap = true,
        },
        {
            "<leader>r",
            ":lua require('fzf-lua').oldfiles({ cwd_only = true, stat_file = true })<CR>",
            desc = "toggle recent files scoped to this directory",
            silent = true,
            noremap = true,
        },
        {
            "<leader>R",
            ":lua require('fzf-lua').oldfiles()<CR>",
            desc = "toggle recent files with no scope (show ALL recent files)",
            silent = true,
            noremap = true,
        },
        {
            "<leader>u",
            ":lua require('fzf-lua').lsp_references()<CR>",
            desc = "find usages (references) for whatever the cursor is on",
            silent = true,
            noremap = true,
        },
        {
            "<leader>i",
            -- symbols are defined here starting on line 556: https://mlir.llvm.org/doxygen/include_2mlir_2Tools_2lsp-server-support_2Protocol_8h_source.html
            -- TODO: this is not filtering on symbols correctly
            ":lua require('fzf-lua').lsp_document_symbols({symbols={'function', 'class', 'method', 'constructor', 'enum', 'interface', 'foo'}})<CR>",
            desc = "find lsp symbols in the current file",
            silent = true,
            noremap = true,
        },
        {
            "<leader>d",
            ":lua require('fzf-lua').diagnostics_document({ bufnr=0, diag_source=true })<CR>",
            desc = "Show LSP diagnostics for the current buffer",
            silent = true,
            noremap = true,
        },
    },
    opts = {
        oldfiles = {
            include_current_session = true,
        },
    },
}
