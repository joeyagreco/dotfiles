local json = require("hs.json")

-- tracks all cmd+shift hotkeys to detect collisions
local reservedKeys = {}

local function bindHotkey(key, description, fn)
    local upper = string.upper(key)
    if reservedKeys[upper] then
        hs.alert.show("hotkey collision: cmd+shift+" .. upper .. " (" .. reservedKeys[upper] .. " vs " .. description .. ")")
        return
    end
    reservedKeys[upper] = description
    hs.hotkey.bind({ "cmd", "shift" }, key, fn)
end

-------------------------------------------
-- shortcut to reload hammerspoon config --
-------------------------------------------
bindHotkey("r", "reload config", function()
    hs.reload()
end)

---------------------------------------
-- maximize the focused window --
---------------------------------------
bindHotkey("A", "maximize window", function()
    local win = hs.window.focusedWindow()
    if win then
        win:setFrame(win:screen():frame(), 0)
    end
end)

-------------------------
-- set up app switcher --
-------------------------

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
    local name = appConfig.appname or appConfig.bundleid
    bindHotkey(key, name, function()
        if appConfig.bundleid then
            hs.application.launchOrFocusByBundleID(appConfig.bundleid)
        else
            hs.application.launchOrFocus(appConfig.appname)
        end
    end)
end
