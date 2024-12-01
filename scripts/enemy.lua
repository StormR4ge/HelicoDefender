local ESTATES = require("scripts/states")
local utils = require("libs/utils")

local Enemy = {}
Enemy.__index = Enemy

function Enemy:new(x, y, r, s, health)
    local enemy = setmetatable({}, Enemy)
    enemy.x = x
    enemy.y = y
    enemy.radius = r
    enemy.speed = s
    enemy.health = health
    enemy.max_health = health
    enemy.dropMoney = 1

    enemy.rotation = 0
    enemy.rotationTurret = 0

    enemy.state = ESTATES.NONE
    enemy.radar = 350
    enemy.attackRange = 100

    enemy.missiles = {}
    enemy.missileSpeed = 100
    enemy.missileDamage = 10
    enemy.fireRate = 1
    enemy.shootCooldown = 0

    enemy.currentTarget = nil

    return enemy
end

function Enemy:fireMissile(target, angle)
    local missileX = self.x
    local missileY = self.y

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

function Enemy:moveTowards(target, dt)
    local dist = utils.distance(self.x, self.y, target.x, target.y)
    if dist > self.attackRange then
        local angle = utils.calculateAngle(self.x, self.y, target.x, target.y)
        self.x = self.x + math.cos(angle) * self.speed * dt
        self.y = self.y + math.sin(angle) * self.speed * dt
    end
end

function Enemy:updateMissiles(dt)
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

function Enemy:update(dt, player, nexus)
    self:updateMissiles(dt)
    self.distToPlayer = utils.distance(self.x, self.y, player.x, player.y) - player.radius
    self.distToNexus = utils.distance(self.x, self.y, nexus.x, nexus.y) - nexus.radius

    if self.state == ESTATES.NONE then
        self.state = ESTATES.WALKNEXUS
    elseif self.state == ESTATES.WALKNEXUS then
        self.currentTarget = nexus
        self:moveTowards(nexus, dt)
        if self.distToNexus < self.attackRange then
            self.state = ESTATES.ATTACKNEXUS
        elseif self.distToPlayer < self.radar then
            self.state = ESTATES.WALKPLAYER
        end
    elseif self.state == ESTATES.ATTACKNEXUS then
        self.currentTarget = nexus
        self:attackTarget(nexus, dt)
    elseif self.state == ESTATES.WALKPLAYER then
        self.currentTarget = player
        self:moveTowards(player, dt)
        if self.distToPlayer > self.radar then
            self.state = ESTATES.WALKNEXUS
        elseif self.distToPlayer < self.attackRange then
            self.state = ESTATES.ATTACKPLAYER
        end
    elseif self.state == ESTATES.ATTACKPLAYER then
        self.currentTarget = player
        self:attackTarget(player, dt)
        if self.distToPlayer > self.attackRange then
            self.state = ESTATES.WALKPLAYER
        end
    end
end

function Enemy:attackTarget(target, dt)
    self.shootCooldown = self.shootCooldown - dt
    if self.shootCooldown <= 0 then
        local angle = utils.calculateAngle(self.x, self.y, target.x, target.y)
        if self.fireMissile then
            self:fireMissile(target, angle)
        end
        self.shootCooldown = self.fireRate
    end
end

function Enemy:drawMissiles(self)
    for _, missile in ipairs(self.missiles) do
        love.graphics.setColor(0, 1, 0)
        love.graphics.circle("fill", missile.x, missile.y, 5)
    end
end

function Enemy:draw()
    bar_width = self.radius * 2
    bar_height = 10
    health_percentage = self.health / self.max_health
    bar_x = self.x - self.radius
    bar_y = self.y - self.radius - 20

    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("line", bar_x, bar_y, bar_width, bar_height)
    love.graphics.rectangle("fill", bar_x, bar_y, bar_width * health_percentage, bar_height)

    love.graphics.setColor(1, 1, 1)

    Enemy:drawMissiles(self)
end

return Enemy
