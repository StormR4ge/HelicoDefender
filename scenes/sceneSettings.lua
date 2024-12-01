local button = require("libs/button")
local keybindings = require("libs/keybindings")
local utils = require("libs/utils")
local ww, wh = utils.getScreenDimensions()

local backGround = love.graphics.newImage("assets/images/ui/bg_01.png")
local settingsBackGround = love.graphics.newImage("assets/images/ui/bg_setting.png")
local imageBt = love.graphics.newImage("assets/images/ui/popup_bg_01.png")
local settingsImage = love.graphics.newImage("assets/images/ui/setting.png")
local bgKeyConf = love.graphics.newImage("assets/images/ui/bgKeyConf.png")
local barreInfo = love.graphics.newImage("assets/images/ui/info.png")

local marge = 20

local sceneSettings = {}

local buttonsKey = {}
local originalKeypressed = nil
waitingKeyAss = false

local function waitForKey(action, btn)
    print("Appuie sur une nouvelle touche pour : " .. action)
    waitingKeyAss = true

    originalKeypressed = love.keypressed
    love.keypressed = function(newKey)
        if newKey == "escape" then
            print("Annulation d'assignation de touche")
            love.keypressed = nil
            waitingKeyAss = false
            love.keypressed = originalKeypressed
            originalKeypressed = nil
            return
        end
        keybindings.changeKey(action, newKey)
        print("Nouvelle touche pour " .. action .. " : " .. newKey)
        setupButtons()

        waitingKeyAss = false
        love.keypressed = originalKeypressed
        originalKeypressed = nil
    end

    love.mousepressed = function(x, y, button, istouch, presses)
        if button == 1 and waitingKeyAss == true then
            keybindings.changeKey(action, "1")
            print("Nouvelle touche pour " .. action .. " : mouse")
            setupButtons()

            waitingKeyAss = false
            love.keypressed = originalKeypressed
            originalMousepressed = nil
        else
            if button == 2 and waitingKeyAss == true then
                keybindings.changeKey(action, "2")
                print("Nouvelle touche pour " .. action .. " : mouse")
                setupButtons()

                waitingKeyAss = false
                love.keypressed = originalKeypressed
                originalMousepressed = nil
            end
        end
    end
end

function setupButtons()
    buttons = {
        button.new(
            "Up : " .. keybindings.keysConfig.up,
            function()
                waitForKey("up", buttons[1])
            end,
            imageBt
        ),
        button.new(
            "Down : " .. keybindings.keysConfig.down,
            function()
                waitForKey("down", buttons[2])
            end,
            imageBt
        ),
        button.new(
            "Left : " .. keybindings.keysConfig.left,
            function()
                waitForKey("left", buttons[3])
            end,
            imageBt
        ),
        button.new(
            "Right : " .. keybindings.keysConfig.right,
            function()
                waitForKey("right", buttons[4])
            end,
            imageBt
        ),
        button.new(
            "shoot : " .. keybindings.keysConfig.shoot,
            function()
                waitForKey("shoot", buttons[5])
            end,
            imageBt
        ),
        button.new(
            "gatling : " .. keybindings.keysConfig.gatling,
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
end

function sceneSettings.draw()
    love.graphics.setColor(1, 1, 1)
    if isInGame ~= "settingsInGame" then
        love.graphics.draw(backGround)
    end

    love.graphics.draw(settingsBackGround, wh * 0.25)
    love.graphics.draw(settingsImage, ww * 0.5 - 150.1, wh * 0.1)

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

return sceneSettings
