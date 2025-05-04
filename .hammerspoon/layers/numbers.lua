local eventtapRemap = nil

local keymap = {
    a = "1",
    s = "2",
    d = "3",
    f = "4",
    g = "5",
    h = "6",
    j = "7",
    k = "8",
    l = "9",
    [";"] = "0",
}

return {
    name = "Numbers",

    enter = function()
        eventtapRemap = hs.eventtap
            .new({ hs.eventtap.event.types.keyDown }, function(event)
                local key = event:getCharacters()
                local mapped = keymap[key]
                if mapped then
                    hs.eventtap.keyStroke({}, mapped, 0)
                    return true
                end
                return false
            end)
            :start()
    end,

    exit = function()
        if eventtapRemap then
            eventtapRemap:stop()
            eventtapRemap = nil
        end
    end,
}
