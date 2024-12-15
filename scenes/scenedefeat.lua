local scenedefeat = {}
local utils = require("libs/utils")
local width, height = utils.getScreenDimensions()

local gameOver = love.graphics.newImage("assets/images/ui/gameover.png")

gameOverOriginX = gameOver:getWidth() * 0.5
gameOverOriginY = gameOver:getHeight() * 0.5

function scenedefeat.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(gameOver, width * 0.5, height * 0.66, 0, 1, 1, gameOverOriginX, gameOverOriginY)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Press [Escape] to return to the main menu.", width * 0.35, height * 0.90)
    love.graphics.setColor(1, 1, 1)
end

return scenedefeat
