local player = {}
player.missiles = {}
local utils = require("libs/utils")
local sceneManager = require("scenes/sceneManager")
local keybindings = require("libs/keybindings")
local scenePause = require("scenes/scenePause")
local width, height = utils.getScreenDimensions()

local imagePlayer = love.graphics.newImage("assets/images/characters/player.png")
local imagePlayerShadow = love.graphics.newImage("assets/images/characters/playerShadow.png")

local imageMissile = love.graphics.newImage("assets/images/characters/attack_helicopter_misil.png")

gatlingStartShootSound = love.audio.newSource("assets/sounds/effects/minigunStart.mp3", "static")
gatlingShootSound = love.audio.newSource("assets/sounds/effects/minigunShoot.mp3", "static")
gatlingOverHeatSound = love.audio.newSource("assets/sounds/effects/minigunOverHeat.mp3", "static")

MissileSound = love.audio.newSource("assets/sounds/effects/missile.mp3", "static")
function player.pause()
    if isPaused == true then
        gatlingShootSound:setLooping(false)
    else
        gatlingShootSound:setLooping(true)
    end
end
function player.load()
    player.x = width / 2
    player.y = height / 2
    player.radius = 70
    player.speed = 200
    player.attackRadius = 15
    player.missileSpeed = 1000
    player.attackSpeed = 5
    player.lastAttackTime = 0
    player.canShoot = true
    player.missileDamage = 100
    player.health = 100
    player.max_health = player.health
    player.heal = 100

    player.gatlingSpeed = 0.05
    player.lastGatlingShot = 0
    player.isGatlingActive = false
    player.gatlingOverheat = 0
    player.maxOverheat = 200
    player.overheatCooldown = 50
    player.gatlingDamage = 10
    player.gatlingBulletSpeed = 1500
end

function player.unload()
    for i = #player.missiles, 1, -1 do
        table.remove(player.missiles, i)
    end
end

function player:fireMissile(type, x, y, angle, speed, damage)
    table.insert(
        self.missiles,
        {
            x = x,
            y = y,
            angle = angle,
            speed = speed,
            damage = damage,
            type = type
        }
    )
end

function player:updateMissiles(dt)
    for i = #self.missiles, 1, -1 do
        local missile = self.missiles[i]
        missile.x = missile.x + math.cos(missile.angle) * missile.speed * dt
        missile.y = missile.y + math.sin(missile.angle) * missile.speed * dt

        if
            missile.x < 0 or missile.x > love.graphics.getWidth() or missile.y < 0 or
                missile.y > love.graphics.getHeight()
         then
            table.remove(self.missiles, i)
        end
    end
end

function player.update(dt)
    if player.health <= 0 then
        player.health = 0
    end
    player:updateMissiles(dt)
    local mouseX, mouseY = love.mouse.getPosition()
    playerAngle = utils.calculateAngle(player.x, player.y, mouseX, mouseY)

    if love.keyboard.isDown(keybindings.keysConfig.left) then
        player.x = player.x - player.speed * dt
    elseif love.keyboard.isDown(keybindings.keysConfig.right) then
        player.x = player.x + player.speed * dt
    end

    if love.keyboard.isDown(keybindings.keysConfig.up) then
        player.y = player.y - player.speed * dt
    elseif love.keyboard.isDown(keybindings.keysConfig.down) then
        player.y = player.y + player.speed * dt
    end

    player.lastAttackTime = player.lastAttackTime + dt

    if love.mouse.isDown(keybindings.keysConfig.shoot) and player.lastAttackTime >= player.attackSpeed then
        if player.canShoot then
            if not player.MissileSound then
                love.audio.play(MissileSound)
            end
            player:fireMissile(
                "missile",
                player.attackRX,
                player.attackRY,
                playerAngle,
                player.missileSpeed,
                player.missileDamage
            )
            player:fireMissile(
                "missile",
                player.attackLX,
                player.attackLY,
                playerAngle,
                player.missileSpeed,
                player.missileDamage
            )
            player.lastAttackTime = 0
            player.canShoot = false
        end
    end

    if not love.mouse.isDown(1) then
        player.canShoot = true
    end

    if love.mouse.isDown(keybindings.keysConfig.gatling) then
        if player.gatlingOverheat < player.maxOverheat then
            player.isGatlingActive = true
            player.lastGatlingShot = player.lastGatlingShot + dt

            if not player.startedGatling then
                love.audio.play(gatlingStartShootSound)
                player.startedGatling = true
            end

            if not gatlingShootSound:isPlaying() then
                love.audio.play(gatlingShootSound)
            end

            if player.lastGatlingShot >= player.gatlingSpeed then
                player:fireMissile(
                    "gatling",
                    player.gatlingX,
                    player.gatlingY,
                    playerAngle,
                    player.gatlingBulletSpeed,
                    player.gatlingDamage
                )
                player.lastGatlingShot = 0
                player.gatlingOverheat = player.gatlingOverheat + 1

                player.lastGatlingShot = 0
                player.gatlingOverheat = player.gatlingOverheat + 1
            end
        else
            if not player.isOverheated then
                love.audio.stop(gatlingShootSound)
                love.audio.play(gatlingOverHeatSound)
                player.isOverheated = true
            end
        end
    else
        if player.startedGatling then
            love.audio.stop(gatlingShootSound)
            love.audio.stop(gatlingStartShootSound)
            player.startedGatling = false
        end
        player.isGatlingActive = false
        player.isOverheated = false
    end

    if not player.isGatlingActive and player.gatlingOverheat > 0 then
        player.gatlingOverheat = math.max(0, player.gatlingOverheat - player.overheatCooldown * dt)
    end

    player.attackRX = player.x + player.attackRadius * math.cos(playerAngle + math.pi / 2)
    player.attackRY = player.y + player.attackRadius * math.sin(playerAngle + math.pi / 2)
    player.attackLX = player.x + player.attackRadius * math.cos(playerAngle - math.pi / 2)
    player.attackLY = player.y + player.attackRadius * math.sin(playerAngle - math.pi / 2)

    player.gatlingX = player.x + player.radius * math.cos(playerAngle)
    player.gatlingY = player.y + player.radius * math.sin(playerAngle)
end

function player:drawMissiles()
    for _, missile in ipairs(self.missiles) do
        if missile.type == "gatling" then
            love.graphics.setColor(1, 1, 0)
            love.graphics.circle("fill", missile.x, missile.y, 3)
        else
            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(
                imageMissile,
                missile.x,
                missile.y,
                missile.angle,
                1,
                1,
                imageMissile:getWidth() / 2,
                imageMissile:getHeight() / 2
            )
        end
    end
end

function player.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(
        imagePlayerShadow,
        player.x - 50,
        player.y - 20,
        playerAngle,
        1,
        1,
        imagePlayer:getWidth() / 2,
        imagePlayer:getHeight() / 2
    )
    love.graphics.draw(
        imagePlayer,
        player.x,
        player.y,
        playerAngle,
        1,
        1,
        imagePlayer:getWidth() / 2,
        imagePlayer:getHeight() / 2
    )

    player:drawMissiles()
end

return player
