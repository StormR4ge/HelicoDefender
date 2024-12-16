local sceneManager = {}

local currentScene
local overlayScene
local button = require("libs/button")
love.window.setMode(1920, 1080, {resizable = true, vsync = false, msaa = 4})

function sceneManager.unloadScene()
    if currentScene and currentScene.unload then
        currentScene.unload()
    end
    currentScene = nil
end

function sceneManager.load()
    if overlayScene and overlayScene.load then
        overlayScene.load()
    end
end

function sceneManager.setScene(scene)
    sceneManager.unloadScene()
    currentScene = scene
    if currentScene and currentScene.load then
        currentScene.load()
    end
end

function sceneManager.setOverlayScene(scene)
    overlayScene = scene
    if overlayScene and overlayScene.load then
        overlayScene.load()
    end
end

function sceneManager.update(dt)
    if currentScene and currentScene.update then
        currentScene.update(dt)
    end
    if overlayScene and overlayScene.update then
        overlayScene.update(dt)
    end
end

function sceneManager.draw()
    if currentScene and currentScene.draw then
        currentScene.draw()
    end
    if overlayScene and overlayScene.draw then
        overlayScene.draw()
    end
end

function sceneManager.keypressed(key)
    if overlayScene and overlayScene.keypressed then
        overlayScene.keypressed(key)
    end

    if currentScene and currentScene.keypressed and not paused then
        currentScene.keypressed(key)
    end
end

function sceneManager.mousepressed(x, y, button, istouch, presses)
    if overlayScene and overlayScene.mousepressed then
        overlayScene.mousepressed(x, y, button, istouch, presses)
    end
    if currentScene and currentScene.mousepressed then
        currentScene.mousepressed(x, y, button, istouch, presses)
    end
end

function sceneManager.mousemoved(x, y, dx, dy)
    if overlayScene and overlayScene.mousemoved then
        overlayScene.mousemoved(x, y, dx, dy)
    end
    if currentScene and currentScene.mousemoved then
        currentScene.mousemoved(x, y, dx, dy)
    end
end

-- Scène par défaut
local sceneMenu = require("scenes/sceneMenu")
sceneManager.setScene(sceneMenu)

-- Scène overlay

local scenePause = require("scenes/scenePause")
sceneManager.setOverlayScene(scenePause)

return sceneManager
