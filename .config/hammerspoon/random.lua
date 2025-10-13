----------------------------------------------------------------------------------
-- make it so focused windows automatically go to fullscreen (but NOT maximize) --
----------------------------------------------------------------------------------

--NOTE: use application watcher instead of window.filter (avoids expensive window enumeration and long hammerspoon reload times)
local appWatcher = nil
if appWatcher then
    appWatcher:stop()
    appWatcher = nil
end

appWatcher = hs.application.watcher.new(function(_, eventType, _)
    if eventType == hs.application.watcher.activated then
        hs.timer.doAfter(0.01, function()
            local win = hs.window.focusedWindow()
            if win and win:isStandard() then
                local frame = win:frame()
                local screen = win:screen():frame()
                local widthRatio = frame.w / screen.w
                local heightRatio = frame.h / screen.h

                -- only maximize if window takes up at least 40% of screen in either dimension
                -- NOTE: @joeyagreco - may have to tweak this number
                if widthRatio > 0.4 or heightRatio > 0.4 then
                    win:maximize()
                end
            end
        end)
    end
end)
appWatcher:start()

-------------------------------------
-- don't want to see the dock icon --
-------------------------------------
hs.dockicon.hide()
