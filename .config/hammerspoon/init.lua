-----------------------------------------------
-- time how long it takes to load the config --
-----------------------------------------------
local start_time_ns = hs.timer.absoluteTime()

-------------------------------------------
-- shortcut to reload hammerspoon config --
-------------------------------------------
hs.hotkey.bind({ "cmd", "shift" }, "r", function()
    hs.reload()
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

------------------------------------------------------------------------------------------
-- make it so focused and new windows automatically go to fullscreen (but NOT maximize) --
------------------------------------------------------------------------------------------
-- NOTE: @joeyagreco - this is SLOW (~7.6 seconds) but only on certain machines... figure out why
local window = require("hs.window")
-- maximize new windows automatically
window.filter.default:subscribe(window.filter.windowCreated, function(win)
    hs.timer.doAfter(0.01, function()
        win:maximize()
    end)
end)
-- optionally maximize focused windows too
window.filter.default:subscribe(window.filter.windowFocused, function(win)
    hs.timer.doAfter(0.01, function()
        win:maximize()
    end)
end)

-------------------------------------
-- don't want to see the dock icon --
-------------------------------------
hs.dockicon.hide()

-------------------
-- set up spoons --
-------------------
require("spoons")

-----------------------------
-- alert on config runtime --
-----------------------------
local end_time_ns = hs.timer.absoluteTime()
local elapsed_sec = (end_time_ns - start_time_ns) / 1e9
hs.alert.show(string.format("reloaded hammerspoon config in %.1f seconds", elapsed_sec))
