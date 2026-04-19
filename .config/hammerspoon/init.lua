-- this is the entrypoint for when the hammerspoon config is loaded/reloaded

-----------------------------------------------
-- time how long it takes to load the config --
-----------------------------------------------
local start_time_ns = hs.timer.absoluteTime()

--------------------
-- set up hotkeys --
--------------------
require("hotkeys")

-------------------------------------
-- don't want to see the dock icon --
-------------------------------------
hs.dockicon.hide()

-----------------------------
-- alert on config runtime --
-----------------------------
local end_time_ns = hs.timer.absoluteTime()
local elapsed_sec = (end_time_ns - start_time_ns) / 1e9
if elapsed_sec < 1 then
    hs.alert.show(string.format("reloaded hammerspoon config in %.0f ms", elapsed_sec * 1000))
else
    hs.alert.show(string.format("reloaded hammerspoon config in %.1f seconds", elapsed_sec))
end
