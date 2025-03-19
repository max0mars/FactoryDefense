factory = {
    color = {
        r = 153,
        g = 0,
        b = 255
    },
    name = 'f'
}
font = love.graphics.newFont()

function factory.new(self, x, y, w, h)
    o = {}
    setmetatable(o, self)
    self.__index = self
    o.metal = 100
    o.x = x
    o.y = y
    o.w = w
    o.h = h
    o.health = 1000
    o.textx = o.x + o.w/2
    o.texty = o.y + o.h/2

    return o
end

function factory.takeDamage(self, damage)
    self.health = self.health - damage
    if self.health <= 0 then
        --Game Over!
    end
end

function factory.draw(self)
    love.graphics.setColor(love.math.colorFromBytes(self.color.r, self.color.g, self.color.b))
    love.graphics.rectangle("line", self.x, self.y, self.w,self.h)
    love.graphics.print(self.name, self.textx - font:getWidth(self.name)/2, self.texty - font:getHeight(self.name)/2)

    love.graphics.setColor(1, 1, 1)
    love.graphics.print('metal: ' .. self.metal, 50, 50)
    love.graphics.print('health: ' .. self.health, 50, 70)
    
end