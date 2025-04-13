local json = require("hs.json")

local function loadHotkeys(path, required)
    local file = io.open(path, "r")
    if not file then
        if required then
            hs.alert.show("Missing required hotkey config:\n" .. path)
        end
        return {}
    end
    local content = file:read("*a")
    file:close()
    return json.decode(content) or {}
end

local home = os.getenv("HOME")
-- for base/global hotkey config
local baseHotkeys = loadHotkeys(home .. "/.hammerspoon/hotkeys.json", true)
-- for local machine overrides of hotkey config
local localHotkeys = loadHotkeys(home .. "/.hammerspoon/hotkeys.local.json", false)

-- Merge: localHotkeys override baseHotkeys
for key, app in pairs(localHotkeys) do
    baseHotkeys[key] = app
end

for key, appName in pairs(baseHotkeys) do
    hs.hotkey.bind({ "cmd", "shift" }, key, function()
        hs.application.launchOrFocus(appName)
    end)
end
