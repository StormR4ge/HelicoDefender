local imports = require("libs/require")

function love.load()
    love.window.setTitle("helicoDefender")
    imports.keybindings.load()
    imports.sceneManager.load()
    globalFont = love.graphics.newFont("assets/fonts/CarterOne-Regular.ttf", 30)
    love.graphics.setFont(globalFont)
    love.mouse.setVisible(false)
    cursorGame = love.graphics.newImage("assets/images/ui/cursor_b.png")
    cursorDefault = love.graphics.newImage("assets/images/ui/cursor_a.png")
    cursor = cursorDefault
    cursorOffsetX, cursorOffsetY = 0, 0
end

function love.update(dt)
    imports.sceneManager.update(dt)
    mx, my = love.mouse.getPosition()

    if isInGame == "game" and isPaused ~= "market" then
        cursor = cursorGame
        cursorOffsetX, cursorOffsetY = cursor:getWidth() * 0.5, cursor:getHeight() * 0.5
    else
        cursor = cursorDefault
        cursorOffsetX, cursorOffsetY = 0, 0
    end
end

function love.draw()
    imports.sceneManager.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(cursor, mx - cursorOffsetX, my - cursorOffsetY)
end

function love.keypressed(key)
    imports.sceneManager.keypressed(key)
end
