local button = {}
local clickCooldown = 0.2
local lastClickTime = 0

local priceIcon = love.graphics.newImage("assets/images/ui/icon_coin.png")

function button.new(text, fn, image, pressedImage, clickSound, bgImage, bgOffset, iconImage, iconOffset, price)
    return {
        text = text,
        fn = fn,
        now = false,
        last = false,
        waiting = false,
        image = image,
        pressedImage = pressedImage,
        clickSound = clickSound,
        bgImage = bgImage,
        bgOffset = bgOffset or {x = 0, y = 0},
        iconImage = iconImage,
        iconOffset = iconOffset or {x = 0, y = 0},
        price = price or 0
    }
end

function button.draw(button, x, y, width, height, waitingKeyAss)
    local color = {0.4, 0.4, 0.5, 1.0}
    local mX, mY = love.mouse.getPosition()

    local hot = mX > x and mX < x + width and mY > y and mY < y + height

    if hot or button.waiting then
        color = {0.8, 0.8, 0.9, 1.0}
    end

    if waitingKeyAss then
        button.last = false
        button.now = false
        return
    end

    button.last = button.last or false
    button.now = love.mouse.isDown(1)

    if love.timer.getTime() - lastClickTime >= clickCooldown then
        if button.last and not button.now and hot and not button.waiting then
            if button.clickSound then
                button.clickSound:stop()
                button.clickSound:play()
            end
            button.fn()
            lastClickTime = love.timer.getTime()
        end
    end

    if button.bgImage then
        local bgWidth = button.bgImage:getWidth()
        local bgHeight = button.bgImage:getHeight()
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(
            button.bgImage,
            x + button.bgOffset.x,
            y + button.bgOffset.y,
            0,
            209 / bgWidth,
            247 / bgHeight
        )
    end

    if not button.image and not button.pressedImage then
        love.graphics.setColor(unpack(color))
        love.graphics.rectangle("fill", x, y, width, height)
    end

    local imageToDraw = button.image
    if button.now and hot and button.pressedImage then
        imageToDraw = button.pressedImage
    end

    if imageToDraw then
        local imageWidth = imageToDraw:getWidth()
        local imageHeight = imageToDraw:getHeight()
        local scaleX = width / imageWidth
        local scaleY = height / imageHeight

        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(imageToDraw, x, y, 0, scaleX, scaleY)
    end
    if button.iconImage then
        local iconWidth = button.iconImage:getWidth()
        local iconHeight = button.iconImage:getHeight()
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(
            button.iconImage,
            x + button.iconOffset.x,
            y + button.iconOffset.y,
            0,
            120 / iconWidth,
            105 / iconHeight
        )
    end

    love.graphics.setColor(0, 0, 0, 1)
    local textW = globalFont:getWidth(button.text)
    local textH = globalFont:getHeight(button.text)
    love.graphics.print(button.text, globalFont, x + (width - textW) / 2, y + (height - textH) / 2)

    if button.price and button.price ~= 0 then
        local priceText = tostring(button.price)
        local priceW = globalFont:getWidth(priceText)
        love.graphics.setColor(1, 1, 0)
        love.graphics.print(priceText, x + (width - priceW) / 2, y + height - 125)
        local iconWidth = priceIcon:getWidth()
        local iconHeight = priceIcon:getHeight()
        love.graphics.draw(priceIcon, x + (width + priceW) / 2 + 10, y + height - 115)
    end

    button.last = button.now
end

return button
