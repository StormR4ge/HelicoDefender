local button = require("libs/button")
local keybindings = require("libs/keybindings")
local utils = require("libs/utils")
local audioManager = require("libs/audioManager")
local BASE_VOLUME = audioManager.BASE_VOLUME
local ww, wh = utils.getScreenDimensions()

local backGround = love.graphics.newImage("assets/images/ui/bg_01.png")
local settingsBackGround = love.graphics.newImage("assets/images/ui/bg_setting.png")
local imageBt = love.graphics.newImage("assets/images/ui/popup_bg_01.png")
local settingsImage = love.graphics.newImage("assets/images/ui/setting.png")
local bgKeyConf = love.graphics.newImage("assets/images/ui/bgKeyConf.png")
local barreInfo = love.graphics.newImage("assets/images/ui/info.png")

local marge = 20

local sceneSettings = {}

local sliderX, sliderY = ww * 0.5, wh * 0.75
local sliderWidth, sliderHeight = 200, 20
local handleX = sliderX
local globalVolume = 1
local onVolumeChangeCallback = nil

local buttonsKey = {}
local originalKeypressed = nil
waitingKeyAss = false

local function waitForKey(action, btn)
    waitingKeyAss = true

    originalKeypressed = love.keypressed
    love.keypressed = function(newKey)
        if newKey == "escape" then
            love.keypressed = nil
            waitingKeyAss = false
            love.keypressed = originalKeypressed
            originalKeypressed = nil
            return
        end

        if (action == "shoot" or action == "gatling") and (newKey ~= "1" and newKey ~= "2") then
            return
        end

        keybindings.changeKey(action, newKey)
        setupButtons()
        waitingKeyAss = false
        love.keypressed = originalKeypressed
        originalKeypressed = nil
    end

    love.mousepressed = function(x, y, button, istouch, presses)
        if button == 1 and waitingKeyAss == true and (action == "shoot" or action == "gatling") then
            keybindings.changeKey(action, "1")
        elseif button == 2 and waitingKeyAss == true and (action == "shoot" or action == "gatling") then
            keybindings.changeKey(action, "2")
        else
            return
        end

        setupButtons()
        waitingKeyAss = false
        love.keypressed = originalKeypressed
        originalMousepressed = nil
    end
end

function setupButtons()
    buttons = {
        button.new(
            "Up : " .. keybindings.config.keysConfig.up,
            function()
                waitForKey("up", buttons[1])
            end,
            imageBt
        ),
        button.new(
            "Down : " .. keybindings.config.keysConfig.down,
            function()
                waitForKey("down", buttons[2])
            end,
            imageBt
        ),
        button.new(
            "Left : " .. keybindings.config.keysConfig.left,
            function()
                waitForKey("left", buttons[3])
            end,
            imageBt
        ),
        button.new(
            "Right : " .. keybindings.config.keysConfig.right,
            function()
                waitForKey("right", buttons[4])
            end,
            imageBt
        ),
        button.new(
            "shoot : " .. keybindings.config.keysConfig.shoot,
            function()
                waitForKey("shoot", buttons[5])
            end,
            imageBt
        ),
        button.new(
            "gatling : " .. keybindings.config.keysConfig.gatling,
            function()
                waitForKey("gatling", buttons[6])
            end,
            imageBt
        )
    }
end

function sceneSettings.load()
    keybindings.load()
    setupButtons()

    globalVolume = keybindings.config.volume
    handleX = sliderX + sliderWidth * globalVolume
    onVolumeChangeCallback = callback
    if onVolumeChangeCallback then
        onVolumeChangeCallback(globalVolume)
    end
end

function sceneSettings.draw()
    love.graphics.setColor(1, 1, 1)
    if isInGame ~= "settingsInGame" then
        love.graphics.draw(backGround)
    end

    love.graphics.draw(settingsBackGround, wh * 0.25)
    love.graphics.draw(settingsImage, ww * 0.5 - 150.1, wh * 0.1)

    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.rectangle("fill", sliderX, sliderY, sliderWidth, sliderHeight)

    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", handleX - 5, sliderY - 5, 10, sliderHeight + 10)

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Volume: " .. math.floor(globalVolume * 100) .. "%", sliderX, sliderY - 50)

    local buttonWidth = 196
    local buttonHeight = 182

    local centerX = ww * 0.5
    local centerY = wh * 0.5
    local margin = 20

    local positions = {
        {x = centerX - buttonWidth - margin, y = centerY - buttonHeight - margin},
        {x = centerX - buttonWidth - margin, y = centerY},
        {x = centerX - buttonWidth * 2 - margin * 2, y = centerY},
        {x = centerX, y = centerY},
        {x = centerX + buttonWidth + margin + 50, y = centerY},
        {x = centerX + buttonWidth * 2 + margin * 4, y = centerY}
    }

    for i, btn in ipairs(buttons) do
        local bX = positions[i].x - (buttonWidth * 0.5)
        local bY = positions[i].y - (buttonHeight * 0.5)
        button.draw(btn, bX, bY, buttonWidth, buttonHeight)
    end

    if waitingKeyAss == true then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(barreInfo, (ww * 0.5), (wh * 0.25))
        love.graphics.setColor(0, 0, 0)
        love.graphics.print("Key?", (ww * 0.55), (wh * 0.27))
        love.graphics.print(" or press 'escape'", (ww * 0.51), (wh * 0.29))
    else
        return sceneSettings.draw
    end
end

function sceneSettings.mousepressed(x, y, button)
    if button == 1 and x >= sliderX and x <= sliderX + sliderWidth and y >= sliderY and y <= sliderY + sliderHeight then
        handleX = x
        globalVolume = (handleX - sliderX) / sliderWidth

        local scaledVolume = globalVolume * BASE_VOLUME

        keybindings.changeVolume(globalVolume)

        audioManager.setGlobalVolume(scaledVolume)
    end
end

function sceneSettings.mousemoved(x, y, dx, dy)
    if love.mouse.isDown(1) then
        if x >= sliderX and x <= sliderX + sliderWidth then
            handleX = x
            globalVolume = (handleX - sliderX) / sliderWidth

            local scaledVolume = globalVolume * BASE_VOLUME

            keybindings.changeVolume(globalVolume)

            audioManager.setGlobalVolume(scaledVolume)
        end
    end
end

function sceneSettings.keypressed(key)
    if isInGame == "settings" and key == "escape" then
        require("scenes/sceneManager").setScene(require("scenes/sceneMenu"))
        isInGame = "menu"
    end
    if isInGame == "settingsInGame" and key == "escape" then
        require("scenes/sceneManager").setOverlayScene(require("scenes/scenePause"))
        isInGame = "pause"
    end
end

function sceneSettings.save()
    love.filesystem.write("volume.json", tostring(globalVolume))
end

return sceneSettings
