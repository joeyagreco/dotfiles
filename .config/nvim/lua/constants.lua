local M = {}

M.LOCAL_GIT_REPO_PATH = os.getenv("LOCAL_GIT_REPO_PATH")

-- function to find top-level .git directories
local function find_top_level_git_dirs(base_path)
    local git_dirs = {}
    local uv = vim.loop

    local function is_git_dir(path)
        local stat = uv.fs_stat(path)
        return stat and stat.type == "directory"
    end

    local function scandir(path)
        local handle = uv.fs_scandir(path)
        if not handle then
            return
        end

        while true do
            local name, type = uv.fs_scandir_next(handle)
            if not name then
                break
            end
            if type == "directory" then
                local git_path = path .. "/" .. name .. "/.git"
                if is_git_dir(git_path) then
                    table.insert(git_dirs, path .. "/" .. name)
                end
            end
        end
    end

    scandir(base_path)
    return git_dirs
end

-- set on load
-- this will contain a list of strings of all git dir paths
M.ALL_LOCAL_GIT_REPO_PATHS = find_top_level_git_dirs(M.LOCAL_GIT_REPO_PATH)

return M
