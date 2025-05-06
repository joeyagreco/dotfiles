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
-- for local machine additions and overrides of hotkey config
local localHotkeys = loadHotkeys(home .. "/.hammerspoon/hotkeys.local.json", false)

-- merge: localHotkeys override baseHotkeys
for key, app in pairs(localHotkeys) do
    baseHotkeys[key] = app
end

for key, appName in pairs(baseHotkeys) do
    hs.hotkey.bind({ "cmd", "shift" }, key, function()
        hs.application.launchOrFocus(appName)
    end)
end

-- don't want to see the dock icon
hs.dockicon.hide()

-- make it so focused and new windows automatically go to fullscreen (but NOT maximize)
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

-- set up layers
-- require("layer")
