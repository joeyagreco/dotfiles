-- to test keys in layers: https://en.key-test.ru/
local menubar = hs.menubar.new()
local alert = hs.alert

local layerModules = {}
local layerIndexByName = {}
local currentIndex = 1 -- lua tables are 1-indexed

-- define layers and their activation hotkeys
local layers = {
    { name = "main", key = "M" },
    { name = "numbers", key = "N" },
}

local function updateMenuBarDisplay()
    local layerName = layerModules[currentIndex].name or ("Layer " .. currentIndex)
    menubar:setTitle(layerName .. "  ⌨️")
end

-- layer switching logic
local function enterLayer(index)
    if index == currentIndex then
        updateMenuBarDisplay()
        return
    end

    if layerModules[currentIndex] and layerModules[currentIndex].exit then
        layerModules[currentIndex].exit()
    end

    currentIndex = index

    updateMenuBarDisplay()

    if layerModules[currentIndex].enter then
        layerModules[currentIndex].enter()
    end
end

-- load and register layers
for _, layer in ipairs(layers) do
    local ok, mod = pcall(require, "layers/" .. layer.name)

    if ok and mod and mod.enter and mod.exit then
        table.insert(layerModules, mod)
        layerIndexByName[layer.name] = #layerModules

        hs.hotkey.bind({ "cmd", "shift" }, layer.key, function()
            enterLayer(layerIndexByName[layer.name])
        end)
    else
        alert.show("failed to load layer: " .. layer.name)
    end
end

-- start in main layer
enterLayer(layerIndexByName["main"])

alert.show("loaded " .. tostring(#layerModules) .. " layers")

return {
    enter = enterLayer,
}
