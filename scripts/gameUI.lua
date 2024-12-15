local utils = require("libs/utils")
local width, height = utils.getScreenDimensions()
local player = require("scripts/player")
local wallet = require("scripts/wallet")
local level1 = require("levels/level1")

local bgBar = love.graphics.newImage("assets/images/ui/Common/barrebg.png")
local iHeart = love.graphics.newImage("assets/images/ui/Common/heart.png")

local barRed1 = love.graphics.newImage("assets/images/ui/Common/1.png")
local barRed2 = love.graphics.newImage("assets/images/ui/Common/2.png")
local barRed3 = love.graphics.newImage("assets/images/ui/Common/3.png")

local numberUI = love.graphics.newImage("assets/images/ui/Common/top_status_bg.png")
local goldUI = love.graphics.newImage("assets/images/ui/Common/gage_icon_coin.png")
local skull = love.graphics.newImage("assets/images/ui/Common/skull.png")

local chronos = love.graphics.newImage("assets/images/ui/Common/chronos.png")
local needle = love.graphics.newImage("assets/images/ui/Common/needle.png")

gameUI = {}
chronosOriginX = chronos:getWidth() * 0.5
chronosOriginY = chronos:getHeight() * 0.5
needleOriginX = needle:getWidth() * 0.5
needleOriginY = needle:getHeight() * 0.5

local hW, hH = 81, 71
local barMaxWidth = 272

local bW, bH = 376, 62
local bgX, bgY = 140, 991
local barX, barY = 200, 1000
local heartX, heartY = 99.5, 974

local overheat_x, overheat_y = 168, 980
local overheat_bar_width, overheat_bar_height = 310, 10

function gameUI.draw()
    local health_percentage = player.health / player.max_health
    local overheat_percentage = player.gatlingOverheat / player.maxOverheat

    love.graphics.draw(bgBar, bgX, bgY)

    love.graphics.draw(barRed1, barX, barY)
    love.graphics.draw(barRed2, barX + 14, barY, 0, health_percentage * 1.47, 1)
    love.graphics.draw(barRed3, barX + 14 + (barMaxWidth * health_percentage), barY)

    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle(
        "fill",
        overheat_x,
        overheat_y,
        overheat_bar_width * overheat_percentage,
        overheat_bar_height
    )
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", overheat_x, overheat_y, overheat_bar_width, overheat_bar_height)

    love.graphics.draw(iHeart, heartX, heartY)
    love.graphics.print(player.health, heartX + 10, heartY + 10)

    love.graphics.draw(numberUI, 1608, 10)
    love.graphics.print(wallet.balance, 1700, 17)
    love.graphics.draw(goldUI, 1851, 24)

    local progress = spawnTimer / spawnIncTimer -- Proportion de temps restant
    local angle = -math.pi * 0.5 - progress * 2 * math.pi -- Commence à 12h (top)

    love.graphics.draw(chronos, 1855, 1010, 0, 1, 1, chronosOriginX, chronosOriginY)
    love.graphics.draw(needle, 1855, 1010, angle, 1, 1, needleOriginX, needleOriginY)

    love.graphics.draw(numberUI, 1410, 1007)
    love.graphics.print(kill, 1510, 1014)
    love.graphics.draw(skull, 1650, 1012)
end

return gameUI
