button = {}
button.__index = button

local GLOBAL = 0

function button:new(x, y, width, height, screen, callback)
    local b = {
        x = x,
        y = y,
        width = width,
        height = height,
        callback = callback,
        screen = screen or '',
        hovered = false
    }
    setmetatable(b, button)
    return b
end

function button:click()
    if(self.hovered) then
        return self.callback()
    end
end

function button:checkhover(x, y)
    if x >= self.x and x <= self.x + self.width and
       y >= self.y and y <= self.y + self.height then
        self.hovered = true
    else
        self.hovered = false
    end
end

function button.checkhoverlist(buttons, screen, x, y)
    for _, button in pairs(buttons) do
        if button.screen == screen or button.screen == GLOBAL then
            button:checkhover(x, y)
        end
    end
end

function button.drawButtons(buttons, screen)
    for _, button in pairs(buttons) do
        if button.hovered and (button.screen == screen or button.screen == GLOBAL) then
            love.graphics.setColor(1, 1, 1)
            love.graphics.rectangle('line', button.x, button.y, button.width, button.height)
        end
    end
end

function button.clickbuttons(buttons, screen, x, y)
    for _, button in pairs(buttons) do
        if button.screen == screen or button.screen == GLOBAL then
            button:click()
        end
    end
end

function button.debug(buttons, screen)
    for _, button in pairs(buttons) do
        if button.screen == screen or button.screen == GLOBAL then
            love.graphics.setColor(1, 1, 1)
            love.graphics.rectangle('line', button.x, button.y, button.width, button.height)
        end
    end
end

function round(num, factor)
    factor = factor or 1
    local dif = num % factor
    if dif < (factor / 2) then
        return num - dif
    else
        return num + factor - dif
    end
end

function round_d(num, factor)
    local factor = factor or 1
    local dif = num % factor
    return num - dif
end

function round_u(num, factor)
    local factor = factor or 1
    local dif = num % factor
    return num + factor - dif
end

return button