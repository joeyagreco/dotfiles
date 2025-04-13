local json = require("hs.json")
local hotkeyFile = os.getenv("HOME") .. "/.hammerspoon/hotkeys.json"

local file = io.open(hotkeyFile, "r")
if not file then
    error("Could not open hotkeys.json")
end

local content = file:read("*a")
file:close()

local appHotkeys = json.decode(content)
if not appHotkeys then
    error("Failed to parse hotkeys.json")
end

for key, appName in pairs(appHotkeys) do
    hs.hotkey.bind({ "cmd", "shift" }, key, function()
        hs.application.launchOrFocus(appName)
    end)
end
