return {
    "echasnovski/mini.icons",
    version = "*",
    lazy = true,
    opts = {},
    -- use in place of nvim-web-devicons
    init = function()
        package.preload["nvim-web-devicons"] = function()
            require("mini.icons").mock_nvim_web_devicons()
            return package.loaded["nvim-web-devicons"]
        end
    end,
}
