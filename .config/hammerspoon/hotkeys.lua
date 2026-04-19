-------------------------------------------
-- shortcut to reload hammerspoon config --
-------------------------------------------
hs.hotkey.bind({ "cmd", "shift" }, "r", function()
    hs.reload()
end)

---------------------------------------
-- maximize the focused window --
---------------------------------------
hs.hotkey.bind({ "cmd", "shift" }, "A", function()
    local win = hs.window.focusedWindow()
    if win then
        win:maximize()
    end
end)

-------------------------
-- set up app switcher --
-------------------------

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
local baseHotkeys = loadHotkeys(home .. "/.config/hammerspoon/hotkeys.json", true)
-- for local machine additions and overrides of base hotkey config
local localHotkeys = loadHotkeys(home .. "/.config/hammerspoon/hotkeys.local.json", false)

-- merge: localHotkeys override baseHotkeys
for key, app in pairs(localHotkeys) do
    baseHotkeys[key] = app
end

for key, appConfig in pairs(baseHotkeys) do
    hs.hotkey.bind({ "cmd", "shift" }, key, function()
        if appConfig.bundleid then
            hs.application.launchOrFocusByBundleID(appConfig.bundleid)
        else
            hs.application.launchOrFocus(appConfig.appname)
        end
    end)
end
