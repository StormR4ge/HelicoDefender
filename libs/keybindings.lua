local json = require("libs/json")

local keybindings = {}

keybindings.config = {
    keysConfig = {
        up = "z",
        down = "s",
        left = "q",
        right = "d",
        shoot = "1",
        gatling = "2"
    },
    volume = 1
}

function keybindings.save()
    local data = json.encode(keybindings.config)
    love.filesystem.write("keysConfig.json", data)
end

function keybindings.load()
    if love.filesystem.getInfo("keysConfig.json") then
        local data = love.filesystem.read("keysConfig.json")
        keybindings.config = json.decode(data)

        keybindings.config.keysConfig =
            keybindings.config.keysConfig or
            {
                up = "z",
                down = "s",
                left = "q",
                right = "d",
                shoot = "1",
                gatling = "2"
            }
        keybindings.config.volume = keybindings.config.volume or 1
    else
        keybindings.save()
    end
end

function keybindings.changeKey(action, newKey)
    keybindings.config.keysConfig[action] = newKey
    keybindings.save()
end

function keybindings.changeVolume(newVolume)
    keybindings.config.volume = newVolume
    keybindings.save()
end

return keybindings
