local utils = {}
local wallet = require("scripts/wallet")
local audioManager = require("libs/audioManager")
kill = 0
impactMissileSound = love.audio.newSource("assets/sounds/effects/impactMissile.mp3", "static")
audioManager.registerSound(impactMissileSound)

local screenWidth, screenHeight = love.graphics.getDimensions()

function utils.distance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

function utils.calculateAngle(x1, y1, x2, y2)
    return math.atan2(y2 - y1, x2 - x1)
end

function utils.getScreenDimensions()
    return screenWidth, screenHeight
end

function utils.interpolateAngle(current, target, maxDelta)
    local delta = (target - current + math.pi) % (2 * math.pi) - math.pi

    delta = math.clamp(delta, -maxDelta, maxDelta)

    return current + delta
end

function math.clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

function utils.checkCollision(missile, target)
    local dx = missile.x - target.x
    local dy = missile.y - target.y
    return dx * dx + dy * dy <= target.radius * target.radius
end

function utils.handlePlayer(playerMissiles, enemys)
    for i = #playerMissiles, 1, -1 do
        local missile = playerMissiles[i]
        for j = #enemys, 1, -1 do
            local enemy = enemys[j]
            local distance = math.sqrt((missile.x - enemy.x) ^ 2 + (missile.y - enemy.y) ^ 2)
            if distance <= enemy.radius then
                enemy.health = enemy.health - missile.damage
                table.remove(playerMissiles, i)
                love.audio.stop(MissileSound)
                if missile.type == "missile" then
                    love.audio.play(impactMissileSound)
                end
                if enemy.health <= 0 then
                    table.remove(enemys, j)
                    wallet.add(enemy.dropMoney)
                    kill = kill + 1
                end
                break
            end
        end
    end
end

function utils.handleEnemys(enemyMissiles, nexus, player)
    for i = #enemyMissiles, 1, -1 do
        local missile = enemyMissiles[i]

        local distance = math.sqrt((missile.x - player.x) ^ 2 + (missile.y - player.y) ^ 2)
        if distance <= player.radius then
            player.health = player.health - missile.damage
            table.remove(enemyMissiles, i)

            if player.health <= 0 then
                print("Game Over!")
            end
        end
    end

    for i = #enemyMissiles, 1, -1 do
        local missile = enemyMissiles[i]
        local distance = math.sqrt((missile.x - nexus.x) ^ 2 + (missile.y - nexus.y) ^ 2)
        if distance <= nexus.radius then
            nexus.health = nexus.health - missile.damage
            table.remove(enemyMissiles, i)

            if nexus.health <= 0 then
                print("Nexus détruit!")
            end
        end
    end
end
return utils
