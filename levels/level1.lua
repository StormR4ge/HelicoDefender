local utils = require("libs/utils")
local newHelicopterEnemy = require("scripts/helicopterEnemy")
local newTankEnemy = require("scripts/tankEnemy")
local newDCAEnemy = require("scripts/dcaEnemy")

local level1 = {}

spawnTimer = 5
spawnIncTimer = 5
local spawnInterval = 0
local waveNumber = 1

function level1.load(enemys)
end

function level1.unload()
    spawnTimer = 5
    spawnIncTimer = 10
    spawnInterval = 0
    waveNumber = 2
end

function level1.update(dt, enemys)
    spawnTimer = spawnTimer - dt
    if spawnTimer <= spawnInterval then
        spawnTimer = spawnIncTimer + 5
        if spawnIncTimer == 20 then
            spawnIncTimer = 15
        else
            spawnIncTimer = spawnIncTimer + 5
        end
        level1.generateWave(waveNumber, enemys)
        waveNumber = waveNumber + 1
    end
end

function level1.generateWave(wave, enemys)
    local totalEnemies = wave * 2
    local numHelicopters = math.ceil(totalEnemies * 0.5)
    local numTanks = math.ceil(totalEnemies * 0.3)
    local numDCA = totalEnemies - numHelicopters - numTanks
    for i = 1, numHelicopters do
        local x = math.random(0, love.graphics.getWidth())
        local y = math.random(-100, -50)
        local r = 30
        local s = 50 + math.random() * 50
        local health = 50 + wave * 10
        table.insert(enemys, newHelicopterEnemy(x, y, r, s, health))
    end
    for i = 1, numTanks do
        local x = (math.random(1, 2) == 1) and -50 or (love.graphics.getWidth() + 50)
        local y = math.random(400, 600)
        local r = 50
        local s = 20 + math.random() * 20
        local health = 200 + wave * 20
        table.insert(enemys, newTankEnemy(x, y, r, s, health))
    end
    for i = 1, numDCA do
        local x = math.random(0, love.graphics.getWidth())
        local y = math.random(-50, love.graphics.getHeight() * 0.25)
        local r = 30
        local s = 0
        local health = 150 + wave * 10
        table.insert(enemys, newDCAEnemy(x, y, r, s, health))
    end
end

function level1.draw()
    local roundedTime = math.floor(spawnTimer)
end

return level1
