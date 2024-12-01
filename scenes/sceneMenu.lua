local sceneMenu = {}
local button = require("libs/button")
local utils = require("libs/utils")
local ww, wh = utils.getScreenDimensions()
local menuMusic

local backGround = love.graphics.newImage("assets/images/ui/bg_01.png")

local imageStart = love.graphics.newImage("assets/images/ui/btn_play_n.png")
local imageStartPress = love.graphics.newImage("assets/images/ui/btn_play_f.png")

local imageSetting = love.graphics.newImage("assets/images/ui/btn_cicle_setting_red.png")
local imageSettingPress = love.graphics.newImage("assets/images/ui/btn_cicle_setting_green.png")

local imageClose = love.graphics.newImage("assets/images/ui/btn_cicle_close_red.png")
local imageClosePress = love.graphics.newImage("assets/images/ui/btn_cicle_close_green.png")

local buttons = {}

function sceneMenu.unload()
    if menuMusic then
        menuMusic:stop()
    end
end

function sceneMenu.load()
    menuMusic = love.audio.newSource("assets/sounds/music/menu_theme.mp3", "stream")
    menuMusic:setLooping(true)
    menuMusic:setVolume(0.1)
    menuMusic:play()
    buttons = {}
    table.insert(
        buttons,
        button.new(
            "",
            function()
                require("scenes/sceneManager").setScene(require("scenes/sceneGame"))
                menuMusic:stop()
                isInGame = "game"
                print("Enter to Scene Game")
            end,
            imageStart,
            imageStartPress
        )
    )
    table.insert(
        buttons,
        button.new(
            "",
            function()
                require("scenes/sceneManager").setScene(require("scenes/sceneSettings"))
                isInGame = "settings"
                print("Going to settings")
            end,
            imageSetting,
            imageSettingPress
        )
    )
    table.insert(
        buttons,
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

function sceneMenu.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(backGround)
    local buttonWidth = 197
    local buttonHeight = 172
    local margin = 16
    local cursorY = 0
    local horizontalSpacing = 50

    for i, btn in ipairs(buttons) do
        local totalWidth = (#buttons * buttonWidth) + ((#buttons - 1) * horizontalSpacing)
        local startX = (ww * 0.5) - (totalWidth * 0.5)
        local bX = startX + (i - 1) * (buttonWidth + horizontalSpacing)
        local bY = (wh * 0.75) - (buttonHeight * 0.5)

        button.draw(btn, bX, bY, buttonWidth, buttonHeight)
        cursorY = cursorY + (buttonHeight + margin)
    end
end
return sceneMenu
