local utils = require("libs/utils")
local width, height = utils.getScreenDimensions()

local nexus = {}
function nexus.load()
    nexus.image = love.graphics.newImage("assets/images/environment/nexus.png")

    nexus.x = 936
    nexus.y = height
    nexus.radius = 196.5
    nexus.xI = 741
    nexus.yI = 884
    nexus.health = 500
    nexus.max_health = nexus.health
    nexus.heal = 500
end

function nexus.draw()
    local bar_width = nexus.radius
    local bar_height = 10
    local health_percentage = nexus.health / nexus.max_health
    local bar_x = nexus.x - nexus.radius * 0.5
    local bar_y = nexus.y - nexus.radius - 25

    love.graphics.setColor(1, 1, 1)

    love.graphics.draw(nexus.image, nexus.xI, nexus.yI)
    love.graphics.rectangle("line", bar_x, bar_y, bar_width, bar_height)
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", bar_x, bar_y, bar_width * health_percentage, bar_height)
    love.graphics.setColor(1, 1, 1)
end

return nexus
