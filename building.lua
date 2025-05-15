building = {}
building.__index = entity
font = love.graphics.newFont()

function building:new(tag, x, y, health, hitboxType, hitboxdimensions, color, name)
    o = entity:new(tag, x, y, 'rectangle', hitboxdimensions)
    setmetatable(o, self)
    self.__index = self

    o.x = x
    o.y = y
    o.w = w
    o.h = h
    o.textx = o.x + o.w /2
    o.texty = o.y + o.h /2
    o.color = color
    o.name = name
    return o
end

function building.draw(self)
    love.graphics.setColor(love.math.colorFromBytes(self.color.r, self.color.g, self.color.b))
    love.graphics.rectangle("line", self.x, self.y, self.w,self.h)
    love.graphics.print(self.name, self.textx - font:getWidth(self.name)/2, self.texty - font:getHeight(self.name)/2)
end