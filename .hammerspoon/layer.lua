local menubar = hs.menubar.new()
local alert = hs.alert

local layerModules = {}
local currentIndex = 1 -- Lua tables are 1-indexed

local layerNames = {
    "default",
    "numbers",
}

for _, name in ipairs(layerNames) do
    local ok, mod = pcall(require, "layers/" .. name)

    if ok and mod and mod.enter and mod.exit then
        table.insert(layerModules, mod)
    else
        alert.show("Failed to load layer: " .. name)
    end
end

local function showMenuBarLayer(layerName)
    menubar:setTitle(layerName .. "  ⌨️")
end

local function enterLayer(index)
    if index == currentIndex then
        return
    end

    if layerModules[currentIndex] and layerModules[currentIndex].exit then
        layerModules[currentIndex].exit()
    end

    currentIndex = index

    local name = layerModules[currentIndex].name or ("Layer " .. currentIndex)
    alert.show("Switched to: " .. name)
    showMenuBarLayer(name)

    if layerModules[currentIndex].enter then
        layerModules[currentIndex].enter()
    end
end

local function nextLayer()
    local newIndex = currentIndex + 1
    if newIndex > #layerModules then
        newIndex = 1
    end
    enterLayer(newIndex)
end

local function prevLayer()
    local newIndex = currentIndex - 1
    if newIndex < 1 then
        newIndex = #layerModules
    end
    enterLayer(newIndex)
end

-- Hotkeys to cycle layers
hs.hotkey.bind({ "cmd", "shift" }, "n", nextLayer)
hs.hotkey.bind({ "cmd", "shift" }, "p", prevLayer)

alert.show("Total layers: " .. tostring(#layerModules))

return {
    next = nextLayer,
    prev = prevLayer,
    enter = enterLayer,
}
