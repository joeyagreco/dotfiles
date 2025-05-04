local menubar = hs.menubar.new()
local alert = hs.alert

local layerModules = {}
local layerIndexByName = {}
local currentIndex = 1 -- Lua tables are 1-indexed

local layerNames = {
    "main",
    "numbers",
}

-- Load and register layers
for _, name in ipairs(layerNames) do
    local ok, mod = pcall(require, "layers/" .. name)

    if ok and mod and mod.enter and mod.exit then
        table.insert(layerModules, mod)
        layerIndexByName[name] = #layerModules
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

-- Bind explicit layer switch keys
hs.hotkey.bind({ "cmd", "shift" }, "N", function()
    alert.show("number layer...")
    local index = layerIndexByName["numbers"]
    if index then
        enterLayer(index)
    end
end)

hs.hotkey.bind({ "cmd", "shift" }, "M", function()
    alert.show("main layer...")
    local index = layerIndexByName["main"]
    if index then
        enterLayer(index)
    end
end)

-- Start in default layer
if layerIndexByName["main"] then
    enterLayer(layerIndexByName["main"])
end

alert.show("Total layers: " .. tostring(#layerModules))

return {
    enter = enterLayer,
}
