button = {}
button.__index = button

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

function button:checkClick()
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

function button.checkhoverlist(buttons, keyword, x, y)
    for _, button in pairs(buttons) do
        if button.screen == keyword then
            button:checkhover(x, y)
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