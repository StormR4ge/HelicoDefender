local sceneGame = {}

local sceneMarket = require("scenes/sceneMarket")
local level1 = require("levels/level1")
local nexus = require("scripts/nexus")
local player = require("scripts/player")
enemys = {}
local utils = require("libs/utils")
local scenedefeat = require("scenes/scenedefeat")
local wallet = require("scripts/wallet")
local gameUi = require("scripts/gameUI")

local map = love.graphics.newImage("assets/images/environment/map.png")

function sceneGame.unload()
    player.unload()

    level1.unload()
    kill = 0

    player = nil
    enemys = nil
    nexus = nil

    if player == nil then
        player = require("scripts/player")
    end
    if enemys == nil then
        enemys = {}
    end
    if nexus == nil then
        nexus = require("scripts/nexus")
    end
end

function sceneGame.load()
    sceneMarket.load()
    wallet.load()
    player.load()
    nexus.load()

    level1.load(enemys)
end

function sceneGame.update(dt)
    if isPaused == true or isPaused == "market" or isPaused == "gameOver" then
        player.pause()
        return
    end

    level1.update(dt, enemys)
    player.update(dt)

    utils.handlePlayer(player.missiles, enemys)

    for _, enemy in ipairs(enemys) do
        enemy:update(dt, player, nexus)
        utils.handleEnemys(enemy.missiles, nexus, player)
    end
end

function sceneGame.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(map)
    wallet.draw()
    nexus.draw()
    for _, enemy in ipairs(enemys) do
        enemy:draw()
    end
    player.draw()
    level1.draw()
    sceneMarket.draw()
    gameUI.draw()
    if player.health <= 0 then
        isPaused = "gameOver"
        scenedefeat.draw()
    end
end

return sceneGame
