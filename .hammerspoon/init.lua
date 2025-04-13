-- Map of hotkey -> application name
local appHotkeys = {
    J = "Google Chrome",
    K = "Alacritty",
}

-- Bind each key to launch/focus the corresponding app
for key, appName in pairs(appHotkeys) do
    hs.hotkey.bind({ "cmd", "shift" }, key, function()
        hs.application.launchOrFocus(appName)
    end)
end
