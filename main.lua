local imports = require("libs/require")
function love.load()
    love.window.setTitle("helicoDefender")
    imports.keybindings.load()
    imports.sceneManager.load()
    globalFont = love.graphics.newFont("assets/fonts/CarterOne-Regular.ttf", 30)
    love.graphics.setFont(globalFont)
end

function love.update(dt)
    imports.sceneManager.update(dt)
end

function love.draw()
    imports.sceneManager.draw()
end

function love.keypressed(key)
    imports.sceneManager.keypressed(key)
end
