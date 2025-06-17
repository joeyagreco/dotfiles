-- URL Opener: Opens a popup to quickly type and open URLs
-- Hotkey: cmd + shift + N

local function openURL()
    local script = [[
        try
            set userInput to display dialog "Enter URL:" default answer "" with title "Open URL" buttons {"Cancel", "Open"} default button "Open"
            return text returned of userInput
        on error
            return ""
        end try
    ]]

    local success, output = hs.osascript.applescript(script)

    if success and output and output ~= "" then
        local url = tostring(output)
        if not url:match("^https?://") and not url:match("^ftp://") then
            url = "http://" .. url
        end
        hs.urlevent.openURL(url)
    end
end

-- Bind the hotkey
hs.hotkey.bind({ "cmd", "shift" }, "N", openURL)
