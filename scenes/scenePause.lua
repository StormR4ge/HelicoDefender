local scenePause = {}
local button = require("libs/button")
local utils = require("libs/utils")
local ww, wh = utils.getScreenDimensions()

local buttonsPause = {}

isPaused = false
isInGame = false

function scenePause.load()
    font = defaultfont
    buttonsPause = {}
    table.insert(
        buttonsPause,
        button.new(
            "Resume Game",
            function()
                print("Return to game")
                isPaused = false
                isInGame = "game"
            end
        )
    )
    table.insert(
        buttonsPause,
        button.new(
            "Main Menu",
            function()
                require("scenes/sceneManager").setScene(require("scenes/sceneMenu"))
                print("Enter to Scene Menu")
                isInGame = "menu"
                isPaused = not isPaused
            end
        )
    )
    table.insert(
        buttonsPause,
        button.new(
            "Settings",
            function()
                require("scenes/sceneManager").setOverlayScene(require("scenes/sceneSettings"))
                print("Going to settings")
                isInGame = "settingsInGame"
            end
        )
    )
    table.insert(
        buttonsPause,
        button.new(
            "Leave Game",
            function()
                love.event.quit(0)
            end
        )
    )
end

function scenePause.update(dt)
end

function scenePause.draw()
    if isPaused == true then
        local buttonWidth = ww * (1 / 3)
        local buttonHeight = 64
        local margin = 16
        local cursorY = 0

        for i, btn in ipairs(buttonsPause) do
            local bX = (ww * 0.5) - (buttonWidth * 0.5)
            local bY = (wh * 0.5) - (buttonHeight * #buttonsPause * 0.5) + cursorY
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
