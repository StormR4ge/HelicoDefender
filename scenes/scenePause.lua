local scenePause = {}
local button = require("libs/button")
local utils = require("libs/utils")
local ww, wh = utils.getScreenDimensions()

local imageStart = love.graphics.newImage("assets/images/ui/btn_play_n.png")
local imageStartPress = love.graphics.newImage("assets/images/ui/btn_play_f.png")

local imageMenu = love.graphics.newImage("assets/images/ui/btn_cicle_menu_red.png")
local imageMenuPress = love.graphics.newImage("assets/images/ui/btn_cicle_menu_green.png")

local imageSetting = love.graphics.newImage("assets/images/ui/btn_cicle_setting_red.png")
local imageSettingPress = love.graphics.newImage("assets/images/ui/btn_cicle_setting_green.png")

local imageClose = love.graphics.newImage("assets/images/ui/btn_cicle_close_red.png")
local imageClosePress = love.graphics.newImage("assets/images/ui/btn_cicle_close_green.png")

local buttonsPause = {}

isPaused = false
isInGame = false

function scenePause.load()
    font = defaultfont
    buttonsPause = {}
    table.insert(
        buttonsPause,
        button.new(
            "",
            function()
                isPaused = false
                isInGame = "game"
            end,
            imageStart,
            imageStartPress
        )
    )
    table.insert(
        buttonsPause,
        button.new(
            "",
            function()
                require("scenes/sceneManager").setScene(require("scenes/sceneMenu"))
                isInGame = "menu"
                isPaused = not isPaused
            end,
            imageMenu,
            imageMenuPress
        )
    )
    table.insert(
        buttonsPause,
        button.new(
            "",
            function()
                require("scenes/sceneManager").setOverlayScene(require("scenes/sceneSettings"))
                isInGame = "settingsInGame"
            end,
            imageSetting,
            imageSettingPress
        )
    )
    table.insert(
        buttonsPause,
        button.new(
            "",
            function()
                love.event.quit(0)
            end,
            imageClose,
            imageClosePress
        )
    )
end

function scenePause.update(dt)
end

function scenePause.draw()
    if isPaused == true then
        local buttonWidth = 197
        local buttonHeight = 172
        local margin = 16
        local cursorY = 0
        local horizontalSpacing = 50

        for i, btn in ipairs(buttonsPause) do
            local totalWidth = (#buttonsPause * buttonWidth) + ((#buttonsPause - 1) * horizontalSpacing)
            local startX = (ww * 0.5) - (totalWidth * 0.5)
            local bX = startX + (i - 1) * (buttonWidth + horizontalSpacing)
            local bY = (wh * 0.75) - (buttonHeight * 0.5)

            button.draw(btn, bX, bY, buttonWidth, buttonHeight)
            cursorY = cursorY + (buttonHeight + margin)
        end
    end
end

function scenePause.keypressed(key)
    if isInGame == "game" and isPaused == false and key == "escape" then
        isPaused = true
        isInGame = "pause"
    elseif isInGame == "pause" and isPaused == true and key == "escape" then
        isPaused = false
        isInGame = "game"
    end
    if isInGame == "game" and key == "p" then
        isPaused = "market"
    elseif isInGame == "game" and isPaused == "market" and key == "escape" then
        isPaused = false
        isInGame = "game"
    end
    if isPaused == "gameOver" and key == "escape" then
        require("scenes/sceneManager").setScene(require("scenes/sceneMenu"))
        print("Enter to Scene Menu")
        isInGame = "menu"
        isPaused = not isPaused
    end
end

return scenePause
