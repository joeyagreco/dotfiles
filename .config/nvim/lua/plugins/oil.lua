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

-- show breadcrumbs from the git root in the winbar based on this recipe: https://github.com/stevearc/oil.nvim/blob/master/doc/recipes.md#show-cwd-in-the-winbar
function _G.get_oil_winbar()
    local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
    local directory = require("oil").get_current_dir(bufnr)
    if not directory then
        return ""
    end
    local git_root = vim.fs.root(directory, ".git")
    if not git_root then
        return ""
    end
    local paths = { git_root }
    local relative_path = vim.fs.relpath(git_root, directory)
    if relative_path and relative_path ~= "." then
        for name in vim.gsplit(relative_path, "/", { plain = true }) do
            table.insert(paths, vim.fs.joinpath(paths[#paths], name))
        end
    end
    -- match the look of the dropbar breadcrumbs by reusing its icons, separator, highlights, and padding
    local dropbar_opts = require("dropbar.configs").opts
    local crumbs = {}
    for _, path in ipairs(paths) do
        local icon, icon_highlight = dropbar_opts.icons.kinds.dir_icon(path)
        local name = vim.fs.basename(path):gsub("%%", "%%%%")
        table.insert(crumbs, string.format("%%#%s#%s%%*%s", icon_highlight, icon, name))
    end
    local separator = string.format("%%#DropBarIconUISeparator#%s%%*", dropbar_opts.icons.ui.bar.separator)
    return string.rep(" ", dropbar_opts.bar.padding.left)
        .. table.concat(crumbs, separator)
        .. string.rep(" ", dropbar_opts.bar.padding.right)
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
        win_options = {
            winbar = "%!v:lua.get_oil_winbar()",
        },
        keymaps = {
            ["<C-p>"] = { "actions.preview", opts = { split = "belowright" } },
            ["_"] = {
                callback = function()
                    local oil = require("oil")
                    local git_root = vim.fs.root(oil.get_current_dir() or vim.fn.getcwd(), ".git")
                    oil.open(git_root or vim.fn.getcwd())
                end,
                desc = "open the git root of the current directory, or the cwd if not in a git repo",
                mode = "n",
            },
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
