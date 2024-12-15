local Enemy = require("scripts/enemy")
local utils = require("libs/utils")
local ESTATES = require("scripts/states")

local function newDCAEnemy(x, y, r, s, health)
    local dca = Enemy:new(x, y, r, s, health)
    setmetatable(dca, {__index = Enemy})

    dca.image = love.graphics.newImage("assets/images/enemies/Dca.png")
    dca.turretimage = love.graphics.newImage("assets/images/enemies/DcaTurret.png")

    dca.missileSpeed = 300
    dca.missileDamage = 8
    dca.fireRate = 0.5
    dca.radar = 600
    dca.attackRange = 600
    dca.isStationary = (s == 0)
    dca.dropMoney = 20

    function dca:fireMissile(target, angle)
        local cannonLength = self.radius + 10
        local missileX = self.x + math.cos(angle) * cannonLength
        local missileY = self.y + math.sin(angle) * cannonLength

        table.insert(
            self.missiles,
            {
                x = missileX,
                y = missileY,
                angle = angle,
                speed = self.missileSpeed,
                damage = self.missileDamage
            }
        )
    end

    function dca:update(dt, player, nexus)
        Enemy.update(self, dt, player, nexus)
    end

    function dca:draw()
        Enemy.draw(self)
        local targetRotation = self.rotation
        local turretTargetRotation = self.rotation

        if (self.state == "walkPlayer" or self.state == "walkNexus") and self.currentTarget then
            targetRotation = utils.calculateAngle(self.x, self.y, self.currentTarget.x, self.currentTarget.y)
        end

        if
            (self.state == "walkPlayer" or self.state == "walkNexus" or self.state == "attackPlayer" or
                self.state == "attackNexus") and
                self.currentTarget
         then
            turretTargetRotation = utils.calculateAngle(self.x, self.y, self.currentTarget.x, self.currentTarget.y)
        end

        local rotationSpeed = 10
        local maxDelta = rotationSpeed * love.timer.getDelta()
        self.rotation = utils.interpolateAngle(self.rotation, targetRotation, maxDelta)
        self.rotationTurret = utils.interpolateAngle(self.rotationTurret, turretTargetRotation, maxDelta)

        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(
            self.image,
            self.x,
            self.y,
            self.rotation,
            1,
            1,
            self.image:getWidth() * 0.5,
            self.image:getHeight() * 0.5
        )

        love.graphics.draw(
            self.turretimage,
            self.x,
            self.y,
            self.rotationTurret,
            1,
            1,
            self.turretimage:getWidth() * 0.5,
            self.turretimage:getHeight() * 0.5
        )
    end

    return dca
end

return newDCAEnemy
