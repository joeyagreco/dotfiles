-- auto compile plugins when plugin file is modified
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost */plugin/*.lua source <afile> | PackerCompile
  augroup end
]])
