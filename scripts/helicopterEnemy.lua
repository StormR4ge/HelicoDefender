local Enemy = require("scripts/enemy")
local utils = require("libs/utils")
local ESTATES = require("scripts/states")

local function newHelicopterEnemy(x, y, r, s, health)
    local helicopter = Enemy:new(x, y, r, s, health)
    setmetatable(helicopter, {__index = Enemy})

    helicopter.image = love.graphics.newImage("assets/images/enemies/helico.png")

    helicopter.missileSpeed = 120
    helicopter.missileDamage = 10
    helicopter.fireRate = 1
    helicopter.radar = 400
    helicopter.attackRange = 300
    helicopter.dropMoney = 10

    function helicopter:fireMissile(target, angle)
        local offset = 20
        local missileXRight = self.x + math.cos(angle + math.pi / 6) * offset
        local missileYRight = self.y + math.sin(angle + math.pi / 6) * offset

        local missileXLeft = self.x + math.cos(angle - math.pi / 6) * offset
        local missileYLeft = self.y + math.sin(angle - math.pi / 6) * offset

        table.insert(
            self.missiles,
            {
                x = missileXRight,
                y = missileYRight,
                angle = angle,
                speed = self.missileSpeed,
                damage = self.missileDamage
            }
        )

        table.insert(
            self.missiles,
            {
                x = missileXLeft,
                y = missileYLeft,
                angle = angle,
                speed = self.missileSpeed,
                damage = self.missileDamage
            }
        )
    end

    function helicopter:update(dt, player, nexus)
        self:updateMissiles(dt)

        Enemy.update(self, dt, player, nexus)
    end

    function helicopter:draw()
        Enemy.draw(self)

        local targetRotation = self.rotation

        if
            (self.state == "walkPlayer" or self.state == "walkNexus" or self.state == "attackPlayer" or
                self.state == "attackNexus") and
                self.currentTarget
         then
            targetRotation = utils.calculateAngle(self.x, self.y, self.currentTarget.x, self.currentTarget.y)
        end

        local rotationSpeed = 5
        local maxDelta = rotationSpeed * love.timer.getDelta()
        self.rotation = utils.interpolateAngle(self.rotation, targetRotation, maxDelta)
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
    end

    return helicopter
end

return newHelicopterEnemy
