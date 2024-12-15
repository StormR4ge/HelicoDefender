local Enemy = require("scripts/enemy")
local utils = require("libs/utils")
local ESTATES = require("scripts/states")

local function newTankEnemy(x, y, r, s, health)
    local tank = Enemy:new(x, y, r, s, health)
    setmetatable(tank, {__index = Enemy})

    tank.image = love.graphics.newImage("assets/images/enemies/Tank.png")
    tank.turretimage = love.graphics.newImage("assets/images/enemies/TankTurret.png")

    tank.missileSpeed = 80
    tank.missileDamage = 20
    tank.fireRate = 1.5
    tank.shootCooldown = 0
    tank.radar = 400
    tank.attackRange = 300
    tank.dropMoney = 25

    function tank:fireMissile(target, angle)
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

    function tank:update(dt, player, nexus)
        self:updateMissiles(dt)
        Enemy.update(self, dt, player, nexus)
    end

    function tank:draw()
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

        local rotationSpeed = 5
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

    return tank
end

return newTankEnemy
