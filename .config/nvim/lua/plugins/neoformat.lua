return {
    "sbdchd/neoformat",
    config = function()
        -- https://github.com/sbdchd/neoformat
        -- this is needed because by default, neoformat stops after a formatter succeeds
        vim.g.neoformat_run_all_formatters = 1
        -- TURN ON FOR DEBUGGING ONLY
        -- vim.g.neoformat_verbose = 2

        -----------------------
        -- custom formatters --
        -----------------------
        -- proto
        vim.g.neoformat_proto_buf = {
            exe = "buf",
            args = { "format", "--write" },
            replace = 1, -- Overwrite the file directly
        }

        -- python
        vim.g.neoformat_python_ruff_check = {
            exe = "ruff",
            stdin = 1,
            args = { "check", "-", "--config", vim.fn.expand("$HOME/ruff.toml"), "--fix", "-q" },
            stderr = 1,
        }
        vim.g.neoformat_python_ruff_fmt = {
            exe = "ruff",
            stdin = 1,
            args = { "format", "-", "--config", vim.fn.expand("$HOME/ruff.toml"), "-q" },
            stderr = 1,
        }

        -- vim.g.neoformat_typescript_lintfix = {
        -- 	exe = "npm",
        -- 	args = { "run", "lint", "--fix" },
        -- 	stdin = 0,
        -- 	stderr = 1,
        -- 	replace = 1,
        -- }

        -- to see what filetype to put here, run ":set filetype?" in any buffer to see what to put it as
        vim.g.neoformat_enabled_sh = { "shfmt" }
        vim.g.neoformat_enabled_zsh = { "shfmt" }
        vim.g.neoformat_enabled_go = { "gofmt", "goimports" }
        -- vim.g.neoformat_enabled_yaml = { "yamlfmt" }
        -- vim.g.neoformat_enabled_yml = { "yamlfmt" }
        vim.g.neoformat_enabled_yaml = {}
        vim.g.neoformat_enabled_yml = {}
        vim.g.neoformat_enabled_python = { "ruff_check", "ruff_fmt" }
        vim.g.neoformat_enabled_proto = { "buf" }
        vim.g.neoformat_enabled_typescript = { "prettier" }
        -- don't want to format .tsx files
        vim.g.neoformat_enabled_typescriptreact = {}

        -- Auto format on save using Neoformat
        vim.cmd([[
  augroup fmt
    autocmd!
    autocmd BufWritePre * silent! undojoin | Neoformat
  augroup END
]])
    end
}
