local json = require("hs.json")
local function loadHotkeys(path)
    local file = io.open(path, "r")
    if not file then
        return {}
    end
    local content = file:read("*a")
    file:close()
    return json.decode(content) or {}
end

local home = os.getenv("HOME")
local baseHotkeys = loadHotkeys(home .. "/.hammerspoon/hotkeys.json")
local localHotkeys = loadHotkeys(home .. "/.hammerspoon/hotkeys.local.json")

-- Merge: localHotkeys override baseHotkeys
for key, app in pairs(localHotkeys) do
    baseHotkeys[key] = app
end

for key, appName in pairs(baseHotkeys) do
    hs.hotkey.bind({ "cmd", "shift" }, key, function()
        hs.application.launchOrFocus(appName)
    end)
end
