local sceneMarket = {}

local button = require("libs/button")
local utils = require("libs/utils")
local player = require("scripts/player")
local nexus = require("scripts/nexus")
local wallet = require("scripts/wallet")

local ww, wh = utils.getScreenDimensions()
local marge = 20

amountAtkDamageP = 100
local minLVLMissile = 0
local maxLVLMissile = 5

amountHealP = 150
local minLVLHealPlayer = 0
local maxLVLHealPlayer = 5

amountHealNexus = 200
local minLVLHealNexus = 0
local maxLVLHealNexus = 5

amountGatlingDamage = 50
local minLVLGatling = 0
local maxLVLGatling = 10

local marketBG = love.graphics.newImage("assets/images/ui/bg_setting.png")

local btnNotPress = love.graphics.newImage("assets/images/ui/btn_box_01_green.png")
local btnPress = love.graphics.newImage("assets/images/ui/btn_box_01_dimmed.png")
local imageBG = love.graphics.newImage("assets/images/ui/frame_item.png")

local imageAtkDamageIcon = love.graphics.newImage("assets/images/ui/icon_helico.png")
local imageHealIcon = love.graphics.newImage("assets/images/ui/icon_heart.png")
local imageHealNexusIcon = love.graphics.newImage("assets/images/ui/icon_emergency_kit.png")

local buttons = {}
local sounds = {}

function sceneMarket_playSound(name)
    if sounds[name] then
        sounds[name]:stop()
        sounds[name]:play()
    end
end

function sceneMarket.load()
    sounds = {
        buy = love.audio.newSource("assets/sounds/effects/coin.mp3", "static"),
        error = love.audio.newSource("assets/sounds/effects/error.mp3", "static")
    }
    buttonsMarket = {}
    table.insert(
        buttonsMarket,
        button.new(
            "+ missile",
            function()
                if minLVLMissile < maxLVLMissile and wallet.spend(amountAtkDamageP) then
                    minLVLMissile = minLVLMissile + 1
                    amountAtkDamageP = amountAtkDamageP + 100
                    if minLVLMissile == maxLVLMissile then
                        amountAtkDamageP = "rupture"
                    end
                    player.missileDamage = player.missileDamage + 5
                    buttonsMarket[1].price = amountAtkDamageP

                    sceneMarket_playSound("buy")
                else
                    sceneMarket_playSound("error")
                end
            end,
            btnNotPress,
            btnPress,
            nil,
            imageBG,
            {x = -29, y = -162},
            imageAtkDamageIcon,
            {x = 15, y = -140},
            amountAtkDamageP
        )
    )
    table.insert(
        buttonsMarket,
        button.new(
            "heal",
            function()
                if minLVLHealPlayer < maxLVLHealPlayer and wallet.spend(amountHealP) then
                    minLVLHealPlayer = minLVLHealPlayer + 1
                    amountHealP = amountHealP + 150
                    if minLVLHealPlayer == maxLVLHealPlayer then
                        amountHealP = "rupture"
                    end
                    player.health = player.heal
                    buttonsMarket[2].price = amountHealP
                    sceneMarket_playSound("buy")
                else
                    sceneMarket_playSound("error")
                end
            end,
            btnNotPress,
            btnPress,
            nil,
            imageBG,
            {x = -29, y = -162},
            imageHealIcon,
            {x = 15, y = -140},
            amountHealP
        )
    )
    table.insert(
        buttonsMarket,
        button.new(
            "hp nexus",
            function()
                if minLVLHealNexus < maxLVLHealNexus and wallet.spend(amountHealNexus) then
                    minLVLHealNexus = minLVLHealNexus + 1
                    amountHealNexus = amountHealNexus + 200
                    if minLVLHealNexus == maxLVLHealNexus then
                        amountHealNexus = "rupture"
                    end
                    nexus.health = nexus.heal
                    buttonsMarket[3].price = amountHealNexus
                    sceneMarket_playSound("buy")
                else
                    sceneMarket_playSound("error")
                end
            end,
            btnNotPress,
            btnPress,
            nil,
            imageBG,
            {x = -29, y = -162},
            imageHealNexusIcon,
            {x = 15, y = -140},
            amountHealNexus
        )
    )
    table.insert(
        buttonsMarket,
        button.new(
            "+ gatling",
            function()
                if minLVLGatling < maxLVLGatling and wallet.spend(amountGatlingDamage) then
                    minLVLGatling = minLVLGatling + 1
                    amountGatlingDamage = amountGatlingDamage + 50
                    if minLVLGatling == maxLVLGatling then
                        amountGatlingDamage = "rupture"
                    end
                    player.gatlingDamage = player.gatlingDamage + 5
                    buttonsMarket[4].price = amountGatlingDamage
                    sceneMarket_playSound("buy")
                else
                    sceneMarket_playSound("error")
                end
            end,
            btnNotPress,
            btnPress,
            nil,
            imageBG,
            {x = -29, y = -162},
            imageAtkDamageIcon,
            {x = 15, y = -140},
            amountGatlingDamage
        )
    )
end

function sceneMarket.update(dt)
end

function sceneMarket.draw()
    if isPaused == "market" then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(marketBG, wh * 0.25)

        local buttonWidth = 157
        local buttonHeight = 89
        local margin = 30
        local cursorY = 0
        local horizontalSpacing = 50

        for i, btn in ipairs(buttonsMarket) do
            local totalWidth = (#buttonsMarket * buttonWidth) + ((#buttonsMarket - 1) * horizontalSpacing)
            local startX = (ww * 0.5) - (totalWidth * 0.5)
            local bX = startX + (i - 1) * (buttonWidth + horizontalSpacing)
            local bY = (wh * 0.5) - (buttonHeight * 0.5)
            button.draw(btn, bX, bY, buttonWidth, buttonHeight)
            cursorY = cursorY + (buttonHeight + margin)
        end
    end
    love.graphics.setColor(1, 1, 1)
end

return sceneMarket
