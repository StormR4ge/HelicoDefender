local json = require("libs/json")

local keybindings = {}

keybindings.keysConfig = {
    up = "z",
    down = "s",
    left = "q",
    right = "d",
    shoot = "1",
    gatling = "2"
}

function keybindings.save()
    local data = json.encode(keybindings.keysConfig)
    love.filesystem.write("keysConfig.json", data)
end

function keybindings.load()
    if love.filesystem.getInfo("keysConfig.json") then
        local data = love.filesystem.read("keysConfig.json")
        keybindings.keysConfig = json.decode(data)
    else
        keybindings.save()
    end
end

function keybindings.changeKey(action, newKey)
    keybindings.keysConfig[action] = newKey
    keybindings.save()
end

return keybindings
