-- https://github.com/stevearc/oil.nvim

-- hide git ignored files based on this recipe: https://github.com/stevearc/oil.nvim/blob/master/doc/recipes.md#hide-gitignored-files-and-show-git-tracked-hidden-files
local git_ignored_cache = {}

local function get_git_ignored_names(directory)
    if git_ignored_cache[directory] then
        return git_ignored_cache[directory]
    end
    local result = vim.system(
        { "git", "ls-files", "--ignored", "--exclude-standard", "--others", "--directory" },
        { cwd = directory, text = true }
    ):wait()
    local names = {}
    if result.code == 0 then
        for line in vim.gsplit(result.stdout, "\n", { plain = true, trimempty = true }) do
            names[line:gsub("/$", "")] = true
        end
    end
    git_ignored_cache[directory] = names
    return names
end

return {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = { "echasnovski/mini.icons" },
    keys = {
        {
            "<leader>e",
            ":lua require('oil').open()<CR>",
            desc = "open explorer at the parent directory of the current file",
            silent = true,
            noremap = true,
        },
        {
            "<leader>E",
            ":lua require('oil').close()<CR>",
            desc = "close explorer",
            silent = true,
            noremap = true,
        },
    },
    opts = {
        -- send deleted files to the trash instead of permanently deleting them
        delete_to_trash = true,
        skip_confirm_for_simple_edits = true,
        keymaps = {
            ["<C-p>"] = { "actions.preview", opts = { split = "belowright" } },
        },
        view_options = {
            is_hidden_file = function(name, bufnr)
                for _, pattern in ipairs({ "^%.env", "%.local" }) do
                    if name:match(pattern) then
                        return false
                    end
                end
                local directory = require("oil").get_current_dir(bufnr)
                if not directory then
                    return false
                end
                return get_git_ignored_names(directory)[name] == true
            end,
        },
    },
    config = function(_, opts)
        local refresh = require("oil.actions").refresh
        local original_refresh_callback = refresh.callback
        refresh.callback = function(...)
            git_ignored_cache = {}
            original_refresh_callback(...)
        end
        require("oil").setup(opts)
    end,
}
