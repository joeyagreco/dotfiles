local function focusApp(name)
    hs.application.launchOrFocus(name)
end

hs.hotkey.bind({ "cmd", "shift" }, "J", function()
    focusApp("Google Chrome")
end)

hs.hotkey.bind({ "cmd", "shift" }, "K", function()
    focusApp("Alacritty")
end)
