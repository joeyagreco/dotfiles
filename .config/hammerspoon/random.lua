-----------------------------------------------------------------------------------------------------------
-- make it so focused windows automatically go to fullscreen (but NOT maximize)                          --
-- NOTE: - ive tried a couple ways (with claude code) and none seem to work to resize windows properly   --
-- NOTE: - this DOES cause the config to take several seconds to reload (instead of basically 0 seconds) --
-----------------------------------------------------------------------------------------------------------

local windowFilter = hs.window.filter.new()
windowFilter:subscribe(hs.window.filter.windowFocused, function(win)
    if not win or not win:isStandard() then
        return
    end

    local frame = win:frame()
    local screen = win:screen():frame()
    local widthRatio = frame.w / screen.w
    local heightRatio = frame.h / screen.h

    -- only maximize if window takes up at least 40% of screen in either dimension
    if widthRatio > 0.4 or heightRatio > 0.4 then
        win:maximize()
    end
end)

-------------------------------------
-- don't want to see the dock icon --
-------------------------------------
hs.dockicon.hide()
